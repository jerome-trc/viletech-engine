## C binding generator derived from Genny.

import std/macros, std/strformat, std/strutils

import stdx

const basicTypes = [
    "bool",
    "int8",
    "uint8",
    "int16",
    "uint16",
    "int32",
    "uint32",
    "int64",
    "uint64",
    "int",
    "uint",
    "float32",
    "float64",
    "float"
]

proc toSnakeCase(s: string): string =
    ## Converts NimType to nim_type.
    var prevCap = false
    for i, c in s:
        if c in {'A' .. 'Z'}:
            if result.len > 0 and result[^1] != '_' and not prevCap:
                result.add '_'
            prevCap = true
            result.add c.toLowerAscii()
        else:
            prevCap = false
            result.add c

proc toCapSnakeCase(s: string): string =
    ## Converts NimType to NIM_TYPE.
    var prevCap = false
    for i, c in s:
        if c in {'A' .. 'Z'}:
            if result.len > 0 and result[^1] != '_' and not prevCap:
                result.add '_'
            prevCap = true
        else:
            prevCap = false
        result.add c.toUpperAscii()

proc toCamelCase(s: string): string =
    ## Converts nim_type to NimType.
    var cap = true
    for i, c in s:
        if c == '_':
            cap = true
        else:
            if cap:
                result.add c.toUpperAscii()
                cap = false
            else:
                result.add c

proc toVarCase(s: string): string =
    ## Converts NimType to nimType.
    var i = 0
    while i < s.len:
        if s[i] notin {'A' .. 'Z'}:
            break

        result.add s[i].toLowerAscii()
        inc i

    if i < s.len:
        result.add s[i .. ^1]

proc renameField(s: string): string =
    ## TODO: make configurable.
    return s

proc renameObject(s: string): string =
    ## TODO: make configurable.
    return s

proc renameParam(s: string): string =
    ## TODO: make configurable.
    return s

proc renameProc(s: string): string =
    ## TODO: make configurable.
    return s

proc getSeqName(sym: NimNode): string =
    "NimSeq"
    # TODO
    # if sym.kind == nnkBracketExpr:
    #     result = &"Seq{sym[1]}"
    # else:
    #     result = &"Seq{sym}"
    # result[3] = toUpperAscii(result[3])

proc getName(sym: NimNode): string =
    if sym.kind == nnkBracketExpr:
        sym.getSeqName()
    else:
        sym.repr

proc raises(procSym: NimNode): bool =
    for pragma in procSym.getImpl()[4]:
        if pragma.kind == nnkExprColonExpr and pragma[0].repr == "raises":
            return pragma[1].len > 0

var
    constants {.compiletime.}: string
    typeDecls {.compiletime.}: string
    typeDefs {.compiletime.}: string
    procs {.compiletime.}: string

proc exportTypeC(sym: NimNode): string =
    if sym.kind == nnkBracketExpr:
        if sym[0].repr == "array":
            let
                entryCount = sym[1].repr
                entryType = exportTypeC(sym[2])
            result = &"{entryType}[{entryCount}]"
        elif sym[0].repr == "seq":
            result = sym.getSeqName()
        else:
            error(&"Unexpected bracket expression {sym[0].repr}[")
    elif sym.kind == nnkPtrTy:
        result = &"$pfx_{sym[0].repr}*"
    else:
        result =
            case sym.repr:
            of "string": "char*"
            of "bool": "bool" # TODO: C-standard dependent, configurable.
            of "byte": "uint8_t"
            of "int8": "int8_t"
            of "int16": "int16_t"
            of "int32": "int32_t"
            of "int64", "int": "int64_t" # TODO: platform-dependent.
            of "uint8": "uint8_t"
            of "uint16": "uint16_t"
            of "uint32": "uint32_t"
            of "uint64": "uint64_t"
            of "uint": "uint32_t"
            of "float32": "float"
            of "float64", "float": "double"
            of "Rune": "int32_t"
            of "Vec2": "Vector2"
            of "Mat3": "Matrix3"
            of "", "nil", "None": "void"
            else:
                let subnames = sym.repr.split('.')
                &"$pfx_{subnames[subnames.len() - 1]}"

proc exportTypeC(sym: NimNode, name: string): string =
    if sym.kind == nnkBracketExpr:
        if sym[0].repr == "array":
            let
                entryCount = sym[1].repr
                entryType = exportTypeC(sym[2], &"{name}[{entryCount}]")
            result = &"{entryType}"
        elif sym[0].repr == "seq":
            result = sym.getSeqName() & " " & name
        else:
            error(&"Unexpected bracket expression {sym[0].repr}[")
    else:
        result = exportTypeC(sym) & " " & name

proc dllProc(procName: string, args: openarray[string], restype: string) =
    var argStr = ""

    for arg in args:
        argStr.add(&"{arg}, ")

    argStr.removeSuffix(", ")
    procs.add(&"{restype} {procName}({argStr});\n")
    procs.add("\n")

proc dllProc(procName: string, args: openarray[(NimNode, NimNode)],
    restype: string) =
    var argsConverted: seq[string]

    if args.isEmpty():
        argsConverted.add("void")
    else:
        for (argName, argType) in args:
            argsConverted.add(exportTypeC(argType, renameParam(argName.getName())))

    dllProc(procName, argsConverted, restype)

proc dllProc(procName: string, restype: string) =
    var a: seq[(string)]
    dllProc(procName, a, restype)

proc exportConstC(sym: NimNode) =
    constants.add &"#define {toCapSnakeCase(sym.repr)} {sym.getImpl()[2].repr}\n"
    constants.add("\n")

proc exportEnumC(sym: NimNode) =
    let enumSize = sym.getSize()

    let underlying = case enumSize:
        of 1: "uint8_t"
        of 2: "uint16_t"
        of 4: "uint32_t"
        of 8: "uint64_t"
        else: error(&"enum size cannot be handled: {enumSize}"); ""

    constants.add(&"typedef {underlying} $pfx_{sym.repr};\n\n")
    constants.add("enum {\n")

    for i, entry in sym.getImpl()[2][1 .. ^1]:
        constants.add(&"\t{toCapSnakeCase(sym.repr)}_{toCapSnakeCase(entry.repr)},\n")

    constants.add("};\n\n")

proc exportFlagsetC(sym: NimNode) =
    let flagsetSize = sym.getSize()

    let underlying = case flagsetSize:
        of 1: "uint8_t"
        of 2: "uint16_t"
        of 4: "uint32_t"
        of 8: "uint64_t"
        else: error(&"flagset size cannot be handled: {flagsetSize}"); ""

    constants.add(&"typedef {underlying} {sym.repr}s;\n\n")
    constants.add("enum {\n")

    for i, entry in sym.getImpl()[2][1 .. ^1]:
        constants.add(&"\t{toCapSnakeCase(sym.repr)}_{toCapSnakeCase(entry.repr)} = 1 << {i},\n")

    constants.add("};\n\n")

proc exportProcC(
    sym: NimNode,
    owner: NimNode = nil,
    prefixes: openarray[NimNode] = []
) =
    let
        procName = sym.repr
        procNameSnaked = renameProc(procName)
        procType = sym.getTypeInst()
        procParams = procType[0][1 .. ^1]
        procReturn = procType[0][0]

    var apiProcName = ""

    if owner != nil:
        apiProcName.add &"{toSnakeCase(owner.getName())}_"

    for prefix in prefixes:
        apiProcName.add &"{toSnakeCase(prefix.getName())}_"

    apiProcName.add &"{procNameSnaked}"

    var defaults: seq[(string, NimNode)]
    for identDefs in sym.getImpl()[3][1 .. ^1]:
        let default = identDefs[^1]
        for entry in identDefs[0 .. ^3]:
            defaults.add((entry.repr, default))

    let comments =
        if sym.getImpl()[6][0].kind == nnkCommentStmt:
            sym.getImpl()[6][0].repr
        elif sym.getImpl[6].kind == nnkAsgn and
            sym.getImpl[6][1].kind == nnkStmtListExpr and
            sym.getImpl[6][1][0].kind == nnkCommentStmt:
            sym.getImpl[6][1][0].repr
        else:
            ""

    if comments != "":
        let lines = comments.replace("## ", "").split("\n")
        procs.add "/**\n"
        for line in lines:
            procs.add &" * {line}\n"
        procs.add " */\n"

    var dllParams: seq[(NimNode, NimNode)]

    for param in procParams:
        dllParams.add((param[0], param[1]))

    dllProc(&"$pfx_{apiProcName}", dllParams, exportTypeC(procReturn))

proc exportObjectC(sym: NimNode, constructor: NimNode) =
    let objName = sym.repr

    typeDefs.add &"typedef struct $pfx_{renameObject(objName)} " & "{\n"

    let objectTy = sym.getImpl()[2]
    let recList = objectTy[2]

    for identDefs in recList:
        echo identDefs.treeRepr
        for property in identDefs[0 .. ^3]:
            if property.kind == nnkPostfix:
                typeDefs.add(&"    {exportTypeC(identDefs[^2], renameObject(property[1].repr))};\n")
            else:
                typeDefs.add(&"    {exportTypeC(identDefs[^2])} ")

                for child in identDefs:
                    if child.kind == nnkIdent:
                        typeDefs.add(&"{renameObject(child.repr)}, ");

                typeDefs.removeSuffix(", ")
                typeDefs.add(";\n")
                break

    typeDefs.add(&"}} $pfx_{renameObject(objName)};\n\n")

    return

    if constructor != nil:
        exportProcC(constructor)
    else:
        procs.add(&"$pfx_{renameObject(objName)} $pfx_init{renameObject(objName)}(")

        let objectTy = sym.getImpl()[2]
        let recList = objectTy[2]

        for identDefs in recList:
            for property in identDefs[0 .. ^3]:
                procs.add &"{exportTypeC(identDefs[^2], toSnakeCase(property[1].repr))}, "

        procs.removeSuffix(", ")
        procs.add(");\n\n")

    dllProc(&"$pfx_{renameObject(objName)}Eq",
        [&"$pfx_{renameObject(objName)} a", &"$pfx_{renameObject(objName)} b"],
        "bool")

proc exportOpaqueC(sym: NimNode) =
    typeDecls.add(&"typedef struct $pfx_{sym.repr}Opq* $pfx_{sym.repr};\n\n")

proc genRefObject(objName: string) =
    # TODO
    # types.add &"typedef struct $pfx_{objName}_s* $pfx_{objName};\n\n"
    # let unrefLibProc = &"$pfx_{renameObject(objName)}_unref"
    # dllProc(unrefLibProc, [objName & " " & renameObject(objName)], "void")
    discard

proc genSeqProcs(objName, procPrefix, selfSuffix: string, entryType: NimNode) =
    let objArg = objName & " " & renameObject(objName)
    dllProc(&"{procPrefix}Len", [objArg], "size_t")
    dllProc(&"{procPrefix}Get", [objArg, "size_t index"], exportTypeC(entryType))
    dllProc(&"{procPrefix}Set", [objArg, "size_t index", exportTypeC(
        entryType, "value")], "void")
    dllProc(&"{procPrefix}Delete", [objArg, "size_t index"], "void")
    dllProc(&"{procPrefix}Add", [objArg, exportTypeC(entryType, "value")], "void")
    dllProc(&"{procPrefix}Clear", [objArg], "void")

proc exportRefObjectC(
    sym: NimNode,
    fields: seq[(string, NimNode)],
    constructor: NimNode
) =
    let
        objName = sym.repr
        objNameR = renameObject(objName)
        # objType = sym.getType()[1].getType()

    genRefObject(objName)

    if constructor != nil:
        let
            constructorLibProc = &"$pfx_{renameProc(constructor.repr)}"
            constructorType = constructor.getTypeInst()
            constructorParams = constructorType[0][1 .. ^1]
            # constructorRaises = constructor.raises()

        var dllParams: seq[(NimNode, NimNode)]
        for param in constructorParams:
            dllParams.add((param[0], param[1]))
        dllProc(constructorLibProc, dllParams, objName)

    for (fieldName, fieldType) in fields:
        let fieldNameR = renameField(fieldName)

        if fieldType.kind != nnkBracketExpr:
            let getProcName = &"$pfx_{objNameR}_get_{fieldNameR}"
            let setProcName = &"$pfx_{objNameR}_set_{fieldNameR}"

            dllProc(getProcName, [objName & " " & objNameR], exportTypeC(fieldType))
            dllProc(setProcName, [objName & " " & objNameR, exportTypeC(
                fieldType, "value")], exportTypeC(nil))
        else:
            var helperName = fieldName
            helperName[0] = toUpperAscii(helperName[0])
            # let helperClassName = objName & helperName

            genSeqProcs(
                objName,
                &"$pfx_{objNameR}_{fieldNameR}",
                &".{renameObject(objName)}",
                fieldType[1]
            )

proc exportSeqC(sym: NimNode) =
    let
        seqName = sym.getName()
        seqNameSnaked = toSnakeCase(seqName)

    genRefObject(seqName)

    let newSeqProc = &"$pfx_new_{toSnakeCase(seqName)}"

    dllProc(newSeqProc, seqName)

    genSeqProcs(
        sym.getName(),
        &"$pfx_{seqNameSnaked}",
        "",
        sym[1]
    )

const headerPragmaOnce = """
#pragma once

"""

const headerIncludeGuard = """
#ifndef INCLUDE_$PFX_H
#define INCLUDE_$PFX_H

"""

# TODO: platform-dependent int size.
const headerCommon = """
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

typedef struct NimString {
    int64_t len;
    void* ptr;
} NimString;

typedef struct NimSeq {
    int64_t len;
    void* ptr;
} NimSeq;

"""

const footerIncludeGuard = """
#endif
"""

proc writeC*(dir, lib, prefix: string, pragmaOnce: bool) =
    var content = if pragmaOnce:
        (headerPragmaOnce & headerCommon & typeDecls & constants & typeDefs &
                procs)
    else:
        (headerIncludeGuard & headerCommon & typeDecls & constants & typeDefs &
                procs & footerIncludeGuard)

    content.removeSuffix("\n")

    writeFile(&"{dir}/{lib}.h", content.replace("$pfx", prefix).replace("$PFX",
            prefix.toUpperAscii()))

template discard2(f: untyped): untyped =
    when(compiles do: discard f):
        discard f
    else:
        f

proc asStmtList(body: NimNode): seq[NimNode] =
    ## Nim optimizes StmtList, reverse that:
    if body.kind != nnkStmtList:
        result.add(body)
    else:
        for child in body:
            result.add(child)

proc emptyBlockStmt(): NimNode =
    result = quote do:
        block:
            discard
    result[1].del(0)

macro exportConstsUntyped(body: untyped) =
    result = newNimNode(nnkStmtList)
    for ident in body:
        let varSection = quote do:
            var `ident` = `ident`
        result.add varSection

macro exportConstsTyped(body: typed) =
    for varSection in body.asStmtList:
        let sym = varSection[0][0]
        exportConstC(sym)

template exportConsts*(body: untyped) =
    ## Exports a list of constants.
    exportConstsTyped(exportConstsUntyped(body))

macro exportEnumsUntyped(body: untyped) =
    result = newNimNode(nnkStmtList)

    for i, ident in body:
        let
            name = ident(&"enum{i}")
            varSection = quote do:
                var `name`: `ident`

        result.add(varSection)

macro exportEnumsTyped(body: typed) =
    for varSection in body.asStmtList:
        let sym = varSection[0][1]
        exportEnumC(sym)

template exportEnums*(body: untyped) =
    ## Exports a list of enums.
    exportEnumsTyped(exportEnumsUntyped(body))

proc fieldUntyped(clause, owner: NimNode): NimNode =
    result = emptyBlockStmt()
    result[1].add quote do:
        var
            obj: `owner`
            f = obj.`clause`

proc procUntyped(clause: NimNode): NimNode =
    result = emptyBlockStmt()

    if clause.kind == nnkIdent:
        let
            name = clause
            varSection = quote do:
                var p = `name`
        result[1].add varSection
    else:
        var
            name = clause[0]
            endStmt = quote do:
                discard2 `name`()
        for i in 1 ..< clause.len:
            var
                argType = clause[i]
                argName = ident(&"arg{i}")
            result[1].add quote do:
                var `argName`: `argType`
            endStmt[1].add argName
        result[1].add endStmt

proc procTypedSym(entry: NimNode): NimNode =
    result =
        if entry[1].kind == nnkVarSection:
            entry[1][0][2]
        else:
            if entry[1][^1].kind != nnkDiscardStmt:
                entry[1][^1][0]
            else:
                entry[1][^1][0][0]

proc procTyped(
    entry: NimNode,
    owner: NimNode = nil,
    prefixes: openarray[NimNode] = []
) =
    let procSym = procTypedSym(entry)
    exportProcC(procSym, owner, prefixes)

macro exportFlagsetsUntyped(body: untyped) =
    result = newNimNode(nnkStmtList)

    for i, ident in body:
        let
            name = ident(&"enum{i}")
            varSection = quote do:
                var `name`: `ident`

        result.add(varSection)

macro exportFlagsetsTyped(body: typed) =
    for varSection in body.asStmtList:
        let sym = varSection[0][1]
        exportFlagsetC(sym)

template exportFlagsets*(body: untyped) =
    exportFlagsetsTyped(exportFlagsetsUntyped(body))

macro exportProcsUntyped(body: untyped) =
    result = newNimNode(nnkStmtList)

    for clause in body:
        result.add procUntyped(clause)

macro exportProcsTyped(body: typed) =
    for entry in body.asStmtList:
        procTyped(entry)

template exportProcs*(body: untyped) =
    ## Exports a list of procs.
    ## Procs can just be a name `doX` or fully qualified with `doX(int): int`.
    exportProcsTyped(exportProcsUntyped(body))

macro exportObjectUntyped(sym, body: untyped) =
    result = newNimNode(nnkStmtList)

    let varSection = quote do:
        var obj: `sym`
    result.add varSection

    var
        constructorBlock = emptyBlockStmt()
        procsBlock = emptyBlockStmt()

    for section in body:
        if section.kind == nnkDiscardStmt:
            continue

        case section[0].repr:
        of "constructor":
            constructorBlock[1].add procUntyped(section[1][0])
        of "procs":
            for clause in section[1]:
                procsBlock[1].add procUntyped(clause)
        else:
            error("Invalid section", section)

    result.add constructorBlock
    result.add procsBlock

macro exportObjectTyped(body: typed) =
    let
        sym = body[0][0][1]
        constructorBlock = body[1]
        procsBlock = body[2]

    let constructor =
        if constructorBlock[1].len > 0:
            procTypedSym(constructorBlock[1])
        else:
            nil

    exportObjectC(sym, constructor)

    if procsBlock[1].len > 0:
        var procsSeen: seq[string]
        for entry in procsBlock[1].asStmtList:
            var
                procSym = procTypedSym(entry)
                prefixes: seq[NimNode]
            if procSym.repr notin procsSeen:
                procsSeen.add procSym.repr
            else:
                let procType = procSym.getTypeInst()
                if procType[0].len > 2:
                    prefixes.add(procType[0][2][1])
            exportProcC(procSym, sym, prefixes)

template exportObject*(sym, body: untyped) =
    ## Exports an object, with these sections:
    ## * fields
    ## * constructor
    ## * procs
    exportObjectTyped(exportObjectUntyped(sym, body))

macro exportOpaqueUntyped(body: untyped) =
    result = newNimNode(nnkStmtList)

    for i, ident in body:
        let
            name = ident(&"ptr object{i}")
            varSection = quote do:
                var `name`: `ident`

        result.add(varSection)

macro exportOpaqueTyped(body: typed) =
    for varSection in body.asStmtList:
        let sym = varSection[0][1]
        exportOpaqueC(sym)

template exportOpaque*(body: untyped) =
    exportOpaqueTyped(exportOpaqueUntyped(body))

macro exportSeqUntyped(sym, body: untyped) =
    result = newNimNode(nnkStmtList)

    let varSection = quote do:
        var s: `sym`
    result.add varSection

    for section in body:
        if section.kind == nnkDiscardStmt:
            continue

        case section[0].repr:
        of "procs":
            for clause in section[1]:
                result.add procUntyped(clause)
        else:
            error("Invalid section", section)

macro exportSeqTyped(body: typed) =
    let sym = body.asStmtList()[0][0][1]

    exportSeqC(sym)

    for entry in body.asStmtList()[1 .. ^1]:
        procTyped(entry, sym)

template exportSeq*(sym, body: untyped) =
    ## Exports a regular sequence.
    ## * procs section
    exportSeqTyped(exportSeqUntyped(sym, body))

macro exportRefObjectUntyped(sym, body: untyped) =
    result = newNimNode(nnkStmtList)

    let varSection = quote do:
        var refObj: `sym`
    result.add varSection

    var
        fieldsBlock = emptyBlockStmt()
        constructorBlock = emptyBlockStmt()
        procsBlock = emptyBlockStmt()

    for section in body:
        if section.kind == nnkDiscardStmt:
            continue

        case section[0].repr:
        of "fields":
            for field in section[1]:
                fieldsBlock[1].add fieldUntyped(field, sym)
        of "constructor":
            constructorBlock[1].add procUntyped(section[1][0])
        of "procs":
            for clause in section[1]:
                procsBlock[1].add procUntyped(clause)
        else:
            error("Invalid section", section)

    result.add fieldsBlock
    result.add constructorBlock
    result.add procsBlock

macro exportRefObjectTyped(body: typed) =
    let
        sym = body[0][0][1]
        fieldsBlock = body[1]
        constructorBlock = body[2]
        procsBlock = body[3]

    var fields: seq[(string, NimNode)]
    if fieldsBlock[1].len > 0:
        for entry in fieldsBlock[1].asStmtList:
            case entry[1][1][2].kind:
            of nnkCall:
                fields.add((
                  entry[1][1][2][0].repr,
                  entry[1][1][2].getTypeInst()
                ))
            else:
                fields.add((
                  entry[1][1][2][1].repr,
                  entry[1][1][2][1].getTypeInst()
                ))

    let constructor =
        if constructorBlock[1].len > 0:
            procTypedSym(constructorBlock[1])
        else:
            nil

    exportRefObjectC(sym, fields, constructor)

    if procsBlock[1].len > 0:
        var procsSeen: seq[string]
        for entry in procsBlock[1].asStmtList:
            var
                procSym = procTypedSym(entry)
                prefixes: seq[NimNode]
            if procSym.repr notin procsSeen:
                procsSeen.add procSym.repr
            else:
                let procType = procSym.getTypeInst()
                if procType[0].len > 2:
                    prefixes.add(procType[0][2][1])
            exportProcC(procSym, sym, prefixes)

template exportRefObject*(sym, body: untyped) =
    ## Exports a ref object, with these sections:
    ## * fields
    ## * constructor
    ## * procs
    exportRefObjectTyped(exportRefObjectUntyped(sym, body))

macro writeBindings*(dir, lib, prefix: static[string], pragmaOnce: static[bool]) =
    writeC(dir, lib, prefix, pragmaOnce)

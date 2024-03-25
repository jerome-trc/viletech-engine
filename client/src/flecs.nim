## Wrapper around the FLECS library.

{.compile: "flecs.c".}

const flecs = "<flecs.h>"

type
    WorldObj* {.header: flecs, importc: "ecs_world_t".} = object
    World* = ptr WorldObj
    Entity* {.header: flecs, importc: "ecs_entity_t".} = distinct uint64
    EntityDesc* {.header: flecs, importc: "ecs_entity_desc_t".} = object
        name*: cstring

const
    NullEntity* = 0.Entity

proc `==` *(a, b: Entity): bool {.borrow.}

proc initWorld*(): World {.importc: "ecs_init".}

proc reset*(this: World): cint {.importc: "ecs_fini".}

proc newId*(this: World) {.importc: "ecs_new_id".}

proc initEntity*(
    this: World,
    desc {.codegenDecl: "const $1 $2".}: ptr EntityDesc
): Entity {.importc: "ecs_entity_init".}

proc lookup*(
    this {.codegenDecl: "const $1 $2".}: World,
    path {.codegenDecl: "const char* $2".}: cstring
): Entity {.importc: "ecs_lookup".}

proc getName*(this: World, entity: Entity) {.importc: "ecs_get_name".}

template ecsComponent*(
    world {.codegenDecl: "$1 world".}: untyped,
    componentT: untyped
) =
    block:
        # `ECS_COMPONENT` can only be used in a C function, so generate one.
        proc `ecs componentT`(world {.codegenDecl: "$1 world".}: World) {.inject.} =
            {.emit: ["ECS_COMPONENT(world, ", componentT, ");"].}

        `ecs componentT`(world)

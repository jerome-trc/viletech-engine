# Helper for Find modules

function(
    get_flags_from_pkg_config
    _library_type
    _pc_prefix
    _out_prefix)
    if(NOT ${_pc_prefix}_FOUND)
        set(${_out_prefix}_compile_options
            ""
            PARENT_SCOPE)
        set(${_out_prefix}_link_libraries
            ""
            PARENT_SCOPE)
        set(${_out_prefix}_link_options
            ""
            PARENT_SCOPE)
        set(${_out_prefix}_link_directories
            ""
            PARENT_SCOPE)
        return()
    endif()

    if("${_library_type}" STREQUAL "STATIC")
        set(_cflags ${_pc_prefix}_STATIC_CFLAGS_OTHER)
        set(_link_libraries ${_pc_prefix}_STATIC_LIBRARIES)
        set(_link_options ${_pc_prefix}_STATIC_LDFLAGS_OTHER)
        set(_library_dirs ${_pc_prefix}_STATIC_LIBRARY_DIRS)
    else()
        set(_cflags ${_pc_prefix}_CFLAGS_OTHER)
        set(_link_libraries ${_pc_prefix}_LIBRARIES)
        set(_link_options ${_pc_prefix}_LDFLAGS_OTHER)
        set(_library_dirs ${_pc_prefix}_LIBRARY_DIRS)
    endif()

    # The *_LIBRARIES lists always start with the library itself
    list(REMOVE_AT "${_link_libraries}" 0)

    # Work around CMake's flag deduplication when pc files use `-framework A` instead of `-Wl,-framework,A`
    string(
        REPLACE "-framework;"
                "-Wl,-framework,"
                "_filtered_link_options"
                "${${_link_options}}")

    set(${_out_prefix}_compile_options
        "${${_cflags}}"
        PARENT_SCOPE)
    set(${_out_prefix}_link_libraries
        "${${_link_libraries}}"
        PARENT_SCOPE)
    set(${_out_prefix}_link_options
        "${_filtered_link_options}"
        PARENT_SCOPE)
    set(${_out_prefix}_link_directories
        "${${_library_dirs}}"
        PARENT_SCOPE)
endfunction()

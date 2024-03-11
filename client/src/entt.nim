## Wrapper around the EnTT library.

const entt = "<entt.hpp>"

type
    Registry* {.header: entt, importcpp: "entt::registry".} = object
    Entity* {.header: entt, importcpp: "entt::entity".} = enum
        dummy = 0
        ## Do not construct this directly!

proc create*(this: var Registry): Entity {.header: entt,
        importcpp: "#.create(@)", nodecl.}

proc emplace*[T](this: var Registry, entity: Entity): ptr T {.header: entt,
        importcpp: "#.emplace<'0>(@)", nodecl.}

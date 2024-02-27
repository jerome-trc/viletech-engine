/// @file
/// @brief A structure into which global state will be incrementally accumulated.

#pragma once

#include <cstdint>
#include <entt.hpp>

#include "prelude.hpp"

/// The destination for incrementally-accumulated global state.
struct Core final {
	// Copy constructor is implicitly deleted by `entt::registry`.

	entt::registry registry;

	[[nodiscard]] static Core create() {
		return {
			.registry = entt::registry(),
		};
	}
};

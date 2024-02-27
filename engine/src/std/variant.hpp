/// @file
/// @brief Wraps `<vector>`, adds niceties.

#pragma once

#include <variant>

namespace std {
	template<class... Ts>
	using Variant = variant<Ts...>;
}

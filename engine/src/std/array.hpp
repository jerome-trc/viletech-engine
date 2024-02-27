/// @file
/// @brief Wraps `<array>`, adds niceties.

#pragma once

#include <array>

namespace std {
	template<typename T, size_t N>
	using Array = array<T, N>;
}

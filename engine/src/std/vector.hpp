/// @file
/// @brief Wraps `<vector>`, adds niceties.

#pragma once

#include <vector>

namespace std {
	template<class T, class Allocator>
	using Vec = vector<T, Allocator>;
}

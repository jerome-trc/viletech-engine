/// @file
/// @brief Wraps `<forward_list>`, adds niceties.

#pragma once

#include <forward_list>

namespace std {
	template<class T, class Alloc>
	using FList = forward_list<T, Alloc>;
}

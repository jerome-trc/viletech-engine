/// @file
/// @brief Wraps `<list>`, adds niceties.

#pragma once

#include <list>

namespace std {
	template<class T, class Alloc>
	using List = list<T, Alloc>;
}

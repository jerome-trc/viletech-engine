/// @file
/// @brief Wraps `<initializer_list>`, adds niceties.

#pragma once

#include <initializer_list>

namespace std {
	template<class T>
	using InitList = initializer_list<T>;
}

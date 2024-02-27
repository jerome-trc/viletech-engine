/// @file
/// @brief Wraps `<valarray>`, adds niceties.

#pragma once

#include <valarray>

namespace std {
	template<class T>
	using ValArray = valarray<T>;
}

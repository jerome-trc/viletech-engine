/// @file
/// @brief Wraps `<type_traits>`, adds niceties.

#pragma once

#include <type_traits>

namespace std {
	template<class T, class U>
	using IsSame = is_same<T, U>;
}

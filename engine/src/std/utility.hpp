/// @file
/// @brief Wraps `<utility>`, provides niceties.

#pragma once

#include <utility>

namespace std {
	template<class T1, class T2>
	using Pair = pair<T1, T2>;

	template<class... Ts>
	using Tuple = tuple<Ts...>;
} // namespace std

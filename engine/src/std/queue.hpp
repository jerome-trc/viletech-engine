/// @file
/// @brief Wraps `<queue>`, adds niceties.

#pragma once

#include <queue>

namespace std {
	template<class T, class Container, class Compare>
	using PrioQueue = priority_queue<T, Container, Compare>;
}

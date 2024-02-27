/// @file
/// @brief Wraps `<queue>`, adds niceties.

#include <queue>

namespace std {
	template<class T, class Container, class Compare>
	using PrioQueue = priority_queue<T, Container, Compare>;
}

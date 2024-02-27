/// @file
/// @brief Wraps `<deque>`, adds niceties.

#include <deque>

namespace std {
	template<class T, class Alloc>
	using Deque = deque<T, Alloc>;
}

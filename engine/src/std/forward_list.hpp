/// @file
/// @brief Wraps `<forward_list>`, adds niceties.

#include <forward_list>

namespace std {
	template<class T, class Alloc>
	using FList = forward_list<T, Alloc>;
}

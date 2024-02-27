/// @file
/// @brief Wraps `<list>`, adds niceties.

#include <list>

namespace std {
	template<class T, class Alloc>
	using List = list<T, Alloc>;
}

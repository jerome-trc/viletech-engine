/// @file
/// @brief Wraps `<initializer_list>`, adds niceties.

#include <initializer_list>

namespace std {
	template<class T>
	using InitList = initializer_list<T>;
}

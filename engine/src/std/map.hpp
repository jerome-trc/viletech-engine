/// @file
/// @brief Wraps `<map>`, adds niceties.

#include <map>

namespace std {
	template<class Key, class T, class Cmp, class Alloc>
	using OMap = map<Key, T, Cmp, Alloc>;

	template<class Key, class T, class Cmp, class Alloc>
	using MultiMap = multimap<Key, T, Cmp, Alloc>;
} // namespace std

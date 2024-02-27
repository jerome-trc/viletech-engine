/// @file
/// @brief Wraps `<set>`, adds niceties.

#include <set>

namespace std {
	template<class Key, class Cmp, class Alloc>
	using OSet = set<Key, Cmp, Alloc>;

	template<class Key, class Cmp, class Alloc>
	using MultiSet = multiset<Key, Cmp, Alloc>;
} // namespace std

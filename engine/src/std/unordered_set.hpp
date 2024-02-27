/// @file
/// @brief Wraps `<unordered_set>`, adds niceties.

#pragma once

#include <unordered_set>

namespace std {
	template<class Key, class Hash, class Pred, class Alloc>
	using USet = unordered_set<Key, Hash, Pred, Alloc>;

	template<class Key, class Hash, class Pred, class Alloc>
	using UMultiSet = unordered_multiset<Key, Hash, Pred, Alloc>;
} // namespace std

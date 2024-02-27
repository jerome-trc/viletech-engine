/// @file
/// @brief Wraps `<unordered_map>`, adds niceties.

#include <unordered_map>

namespace std {
	template<class Key, class T, class Hash, class Pred, class Alloc>
	using UMap = unordered_map<Key, T, Hash, Pred, Alloc>;

	template<class Key, class T, class Hash, class Pred, class Alloc>
	using UMultiMap = unordered_map<Key, T, Hash, Pred, Alloc>;
} // namespace std

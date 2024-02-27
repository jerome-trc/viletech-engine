/// @file
/// @brief Wraps `<flat_map>`, adds niceties.

#pragma once

#include <flat_map>

namespace std {
	template<class Key, class T, class Compare, class KeyContainer, class MappedContainer>
	using FlatMap = flat_map<Key, T, Compare, KeyContainer, MappedContainer>;

	template<class Key, class T, class Compare, class KeyContainer, class MappedContainer>
	using FlatMultimap = flat_multimap<Key, T, Compare, KeyContainer, MappedContainer>;
} // namespace std

/// @file
/// @brief Miscellaneous useful things, required broadly.

// - Naturally, many of these identifiers are just stolen from Rust's stdlib.
// - Redundant includes are to satisfy clangd, which seems to mishandle `__has_include`.

#define DELETE_COPIERS(type)    \
	type(const type&) = delete; \
	type& operator=(const type&) = delete;
#define DELETE_MOVERS(type) \
	type(type&&) = delete;  \
	type& operator=(type&&) = delete;

#define DELETE_COPIERS_AND_MOVERS(type) DELETE_COPIERS(type) DELETE_MOVERS(type)

#define s_cast static_cast
#define d_cast dynamic_cast
#define r_cast reinterpret_cast

#if __has_include(<any>)
#include <any>

namespace std {
	using Any = any;
}
#endif

#if __has_include(<array>)
#include <array>

namespace std {
	template<typename T, size_t N>
	using Array = array<T, N>;
}
#endif

#if __has_include(<bitset>)
#include <bitset>

namespace std {
	template<size_t N>
	using Bitset = bitset<N>;
}
#endif

#if __has_include(<deque>)
#include <deque>

namespace std {
	template<class T, class Alloc = allocator<T>>
	using Deque = deque<T, Alloc>;
}
#endif

#if __has_include(<flat_map>)
#include <flat_map>

namespace std {
	template<
		class Key,
		class T,
		class Compare = less<Key>,
		class KeyContainer = vector<Key>,
		class MappedContainer = vector<T>>
	using FlatMap = flat_map<Key, T, Compare, KeyContainer, MappedContainer>;

	template<
		class Key,
		class T,
		class Compare = less<Key>,
		class KeyContainer = vector<Key>,
		class MappedContainer = vector<T>>
	using FlatMultimap = flat_multimap<Key, T, Compare, KeyContainer, MappedContainer>;
} // namespace std
#endif

#if __has_include(<flat_set>)
#include <flat_set>

namespace std {
	template<class Key, class Compare = less<Key>, class KeyContainer = vector<Key>>
	using FlatSet = flat_set<Key, Compare, KeyContainer>;

	template<class Key, class Compare = less<Key>, class KeyContainer = vector<Key>>
	using FlatMultiset = flat_multiset<Key, Compare, KeyContainer>;
} // namespace std
#endif

#if __has_include(<forward_list>)
#include <forward_list>

namespace std {
	template<class T, class Alloc = allocator<T>>
	using FList = forward_list<T, Alloc>;
}
#endif

#if __has_include(<initializer_list>)
namespace std {
	template<class T>
	using InitList = initializer_list<T>;
}
#endif

#if __has_include(<list>)
#include <list>

namespace std {
	template<class T, class Alloc = allocator<T>>
	using List = list<T, Alloc>;
}
#endif

#if __has_include(<map>)
#include <map>

namespace std {
	template<class Key, class T, class Cmp = less<Key>, class Alloc = allocator<pair<const Key, T>>>
	using OMap = map<Key, T, Cmp, Alloc>;

	template<class Key, class T, class Cmp = less<Key>, class Alloc = allocator<pair<const Key, T>>>
	using MultiMap = multimap<Key, T, Cmp, Alloc>;
} // namespace std
#endif

#if __has_include(<mdspan>)
#include <mdspan>

namespace std {
	template<
		class T,
		class Extents,
		class LayoutPolicy = std::layout_right,
		class AccessorPolicy = std::default_accessor<T>>
	using MdSpan = mdspan<T, Extents, LayoutPolicy, AccessorPolicy>;
}
#endif

#if __has_include(<memory>)
#include <memory>

namespace std {
	template<class T>
	using Box = unique_ptr<T>;

	template<class T>
	using SPtr = shared_ptr<T>;

	template<class T>
	using Weak = weak_ptr<T>;
} // namespace std
#endif

#if __has_include(<optional>)
#include <optional>

namespace std {
	template<class T>
	using Option = optional<T>;
}
#endif

#if __has_include(<queue>)
#include <queue>

namespace std {
	template<
		class T,
		class Container = vector<T>,
		class Compare = less<typename Container::value_type>>
	using PrioQueue = priority_queue<T, Container, Compare>;
}
#endif

#if __has_include(<set>)
#include <set>

namespace std {
	template<class Key, class Cmp = less<Key>, class Alloc = allocator<Key>>
	using OSet = set<Key, Cmp, Alloc>;

	template<class Key, class Cmp = less<Key>, class Alloc = allocator<Key>>
	using MultiSet = multiset<Key, Cmp, Alloc>;
} // namespace std
#endif

#if __has_include(<span>)
#include <span>

namespace std {
	template<class T, std::size_t Extent = std::dynamic_extent>
	using Span = span<T, Extent>;
}
#endif

#if __has_include(<stack>)
#include <stack>

namespace std {
	template<
		class T,
		class Container = deque<T>>
	using Stack = stack<T, Container>;
}
#endif

#if __has_include(<string>)
#include <string>

namespace std {
	using String = string;
}
#endif

#if __has_include(<string_view>)
#include <string_view>

namespace std {
	using StrView = string_view;
}
#endif

#if __has_include(<type_traits>)
#include <type_traits>

namespace std {
	template<class T, class U>
	using IsSame = is_same<T, U>;
}
#endif

#if __has_include(<unordered_map>)
#include <unordered_map>

namespace std {
	template<
		class Key,
		class T,
		class Hash = hash<Key>,
		class Pred = equal_to<Key>,
		class Alloc = allocator<pair<const Key, T>>>
	using UMap = unordered_map<Key, T, Hash, Pred, Alloc>;

	template<
		class Key,
		class T,
		class Hash = hash<Key>,
		class Pred = equal_to<Key>,
		class Alloc = allocator<pair<const Key, T>>>
	using UMultiMap = unordered_map<Key, T, Hash, Pred, Alloc>;
} // namespace std
#endif

#if __has_include(<unordered_set>)
#include <unordered_set>

namespace std {
	template<
		class Key,
		class Hash = hash<Key>,
		class Pred = equal_to<Key>,
		class Alloc = allocator<Key>>
	using USet = unordered_set<Key, Hash, Pred, Alloc>;

	template<
		class Key,
		class Hash = hash<Key>,
		class Pred = equal_to<Key>,
		class Alloc = allocator<Key>>
	using UMultiSet = unordered_multiset<Key, Hash, Pred, Alloc>;
} // namespace std
#endif

#if __has_include(<utility>)
namespace std {
	template<class T1, class T2>
	using Pair = pair<T1, T2>;

	template<class... Ts>
	using Tuple = tuple<Ts...>;
} // namespace std
#endif

#if __has_include(<valarray>)
#include <valarray>

namespace std {
	template<class T>
	using ValArray = valarray<T>;
}
#endif

#if __has_include(<variant>)
#include <variant>

namespace std {
	template<class... Ts>
	using Variant = variant<Ts...>;
}
#endif

#if __has_include(<vector>)
#include <vector>

namespace std {
	template<class T, class Allocator = allocator<T>>
	using Vec = vector<T, Allocator>;
}
#endif

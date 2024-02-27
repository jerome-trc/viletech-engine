/// @file
/// @brief Wraps `<bitset>`, adds niceties.

#include <bitset>

namespace std {
	template<size_t N>
	using Bitset = bitset<N>;
}

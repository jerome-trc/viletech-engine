/// @file
/// @brief Wraps `<bitset>`, adds niceties.

#pragma once

#include <bitset>

namespace std {
	template<size_t N>
	using Bitset = bitset<N>;
}

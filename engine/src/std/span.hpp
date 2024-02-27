/// @file
/// @brief Wraps `<span>`, adds niceties.

#include <span>

namespace std {
	template<class T, std::size_t Extent>
	using Span = span<T, Extent>;
}

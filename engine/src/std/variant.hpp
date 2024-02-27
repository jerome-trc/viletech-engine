/// @file
/// @brief Wraps `<vector>`, adds niceties.

#include <variant>

namespace std {
	template<class... Ts>
	using Variant = variant<Ts...>;
}

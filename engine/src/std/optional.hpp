/// @file
/// @brief Wraps `<optional>`, adds niceties.

#include <optional>

namespace std {
	template<class T>
	using Option = optional<T>;
}

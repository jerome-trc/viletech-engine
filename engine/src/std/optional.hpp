/// @file
/// @brief Wraps `<optional>`, adds niceties.

#pragma once

#include <optional>

namespace std {
	template<class T>
	using Option = optional<T>;
}

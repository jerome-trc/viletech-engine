/// @file
/// @brief Wraps `<stack>`, adds niceties.

#pragma once

#include <stack>

namespace std {
	template<class T, class Container>
	using Stack = stack<T, Container>;
}

/// @file
/// @brief Wraps `<stack>`, adds niceties.

#include <stack>

namespace std {
	template<class T, class Container>
	using Stack = stack<T, Container>;
}

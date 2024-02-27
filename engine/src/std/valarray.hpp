/// @file
/// @brief Wraps `<valarray>`, adds niceties.

#include <valarray>

namespace std {
	template<class T>
	using ValArray = valarray<T>;
}

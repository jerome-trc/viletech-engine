/// @file
/// @brief Wraps `<memory>`, adds niceties.

#include <memory>

namespace std {
	template<class T>
	using Box = unique_ptr<T>;

	template<class T>
	using SPtr = shared_ptr<T>;

	template<class T>
	using Weak = weak_ptr<T>;
} // namespace std

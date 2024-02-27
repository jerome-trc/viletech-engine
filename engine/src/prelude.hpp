/// @file
/// @brief Miscellaneous useful things, required broadly.

#define DELETE_COPIERS(type)    \
	type(const type&) = delete; \
	type& operator=(const type&) = delete;
#define DELETE_MOVERS(type) \
	type(type&&) = delete;  \
	type& operator=(type&&) = delete;

#define DELETE_COPIERS_AND_MOVERS(type) DELETE_COPIERS(type) DELETE_MOVERS(type)

#define s_cast static_cast
#define d_cast dynamic_cast
#define r_cast reinterpret_cast

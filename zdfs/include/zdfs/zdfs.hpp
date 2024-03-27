//! @file
//! @brief Common components of the C++17 API for the ZDFS library.

#pragma once

#if __cplusplus >= 201703L
#define ZDFS_NODISCARD [[nodiscard]]
#else
#define ZDFS_NODISCARD
#endif

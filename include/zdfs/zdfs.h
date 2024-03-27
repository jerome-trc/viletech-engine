//! @file
//! @brief C99 API for the ZDFS library.

#pragma once

#include <stddef.h>

#if defined(__cplusplus)
extern "C" {
#endif

#if __STDC_VERSION__ >= 202000L || (defined(__cplusplus) && __cplusplus >= 201703L)
#define ZDFS_NODISCARD [[nodiscard]]
#else
#define ZDFS_NODISCARD
#endif

#if defined(__cplusplus)
}
#endif

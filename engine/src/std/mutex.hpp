/// @file
/// @brief Wraps `<mutex>`, adds niceties.

#pragma once

#include <mutex>

namespace std {
	using AdoptLock = adopt_lock_t;
	using DeferLock = defer_lock_t;
	using Mutex = mutex;
	using OnceFlag = once_flag;
	using RecurMutex = recursive_mutex;
	using RecurTimedMutex = recursive_timed_mutex;
	using TimedMutex = timed_mutex;
	using TryToLock = try_to_lock_t;

	template<class Mtx>
	using LockGuard = lock_guard<Mtx>;

	template<class... MtxTs>
	using ScopedLock = scoped_lock<MtxTs...>;

	template<class Mtx>
	using UniqueLock = unique_lock<Mtx>;
}

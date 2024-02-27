/// @file
/// @brief Wraps `<thread>`, adds niceties.

#pragma once

#include <thread>

namespace std {
	using Thread = thread;
	using JThread = jthread;
}

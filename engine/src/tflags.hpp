/// @file
/// Modified form of GZDoom's `src/common/utility/tflags.h`.

/*

Copyright 2015 Teemu Piippo
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. The name of the author may not be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

#pragma once

#include <cstdint>

/// A Qt-inspired type-safe flagset type.
///
/// T is the enum type of individual flags; TT is the underlying integer type used.
template<typename T, typename TT = uint32_t>
struct TFlags final {
	struct ZeroDummy final { };

public:
	using Self = TFlags<T, TT>;
	using EnumType = T;
	using IntType = TT;

	TFlags() = default;
	TFlags(const Self& other) = default;
	constexpr TFlags(T value) : val(static_cast<TT>(value)) { }

	// This allows initializing the flagset with 0, as 0 implicitly converts into a null pointer.
	constexpr TFlags(ZeroDummy*) : val(0) { }

	constexpr Self operator|(const Self& other) const {
		return Self::from_int(this->val | other.get_value());
	}

	constexpr Self operator&(const Self& other) const {
		return Self::from_int(this->val & other.get_value());
	}

	constexpr Self operator^(const Self& other) const {
		return Self::from_int(this->val ^ other.get_value());
	}

	constexpr Self operator|(T value) const {
		return Self::from_int(this->val | value);
	}

	constexpr Self operator&(T value) const {
		return Self::from_int(this->val & value);
	}

	constexpr Self operator^(T value) const {
		return Self::from_int(this->val ^ value);
	}

	constexpr Self operator~() const {
		return Self::from_int(~this->val);
	}

	// Assignment operators
	constexpr Self& operator=(const Self& other) = default;

	constexpr Self& operator|=(const Self& other) {
		this->val |= other.get_value();
		return *this;
	}

	constexpr Self& operator&=(const Self& other) {
		this->val &= other.get_value();
		return *this;
	}

	constexpr Self& operator^=(const Self& other) {
		this->val ^= other.get_value();
		return *this;
	}

	constexpr Self& operator=(T value) {
		this->val = value;
		return *this;
	}

	constexpr Self& operator|=(T value) {
		this->val |= value;
		return *this;
	}

	constexpr Self& operator&=(T value) {
		this->val &= value;
		return *this;
	}

	constexpr Self& operator^=(T value) {
		this->val ^= value;
		return *this;
	}

	// Access the value of the flagset
	constexpr TT get_value() const {
		return this->val;
	}

	constexpr operator TT() const {
		return this->val;
	}

	/// Set the value of the flagset manually with an integer.
	/// Please think twice before using this.
	static constexpr Self from_int(TT value) {
		return Self(static_cast<T>(value));
	}

private:
	template<typename X>
	constexpr Self operator|(X value) const {
		return Self::from_int(this->val | value);
	}

	template<typename X>
	constexpr Self operator&(X value) const {
		return Self::from_int(this->val & value);
	}

	template<typename X>
	constexpr Self operator^(X value) const {
		return Self::from_int(this->val ^ value);
	}

	TT val;
};

/// Additional operators for `TFlags` types.
#define DEFINE_TFLAGS_OPERATORS(T)                               \
	constexpr inline T operator|(T::EnumType a, T::EnumType b) { \
		return T::FromInt(T::IntType(a) | T::IntType(b));        \
	}                                                            \
	constexpr inline T operator&(T::EnumType a, T::EnumType b) { \
		return T::FromInt(T::IntType(a) & T::IntType(b));        \
	}                                                            \
	constexpr inline T operator^(T::EnumType a, T::EnumType b) { \
		return T::FromInt(T::IntType(a) ^ T::IntType(b));        \
	}                                                            \
	constexpr inline T operator|(T::EnumType a, T b) {           \
		return T::FromInt(T::IntType(a) | T::IntType(b));        \
	}                                                            \
	constexpr inline T operator&(T::EnumType a, T b) {           \
		return T::FromInt(T::IntType(a) & T::IntType(b));        \
	}                                                            \
	constexpr inline T operator^(T::EnumType a, T b) {           \
		return T::FromInt(T::IntType(a) ^ T::IntType(b));        \
	}                                                            \
	constexpr inline T operator~(T::EnumType a) {                \
		return T::FromInt(~T::IntType(a));                       \
	}

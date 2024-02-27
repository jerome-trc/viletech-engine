/// @file
/// @brief Strong fixed-point decimal number types.

#pragma once

#include <cstdint>
#include <std/type_traits.hpp>

/// A strong fixed-point decimal number type.
template<typename Inner>
struct Fxp final {
private:
	Inner bits;

public:
	constexpr explicit Fxp(Inner bits) : bits(bits) { }

	[[nodiscard]] constexpr Fxp operator+(Fxp<Inner> rhs) const {
		return Fxp(this->bits + rhs.bits);
	}

	[[nodiscard]] constexpr Fxp operator-(Fxp<Inner> rhs) const {
		return Fxp(this->bits - rhs.bits);
	}

	[[nodiscard]] constexpr Fxp operator/(Fxp<Inner> rhs) const {
		return Fxp(this->bits / rhs.bits);
	}

	[[nodiscard]] constexpr Fxp operator*(Fxp<Inner> rhs) const {
		return Fxp(this->bits * rhs.bits);
	}

	[[nodiscard]] constexpr explicit operator float() const {
		return this->inner * (1. / (1 << Fxp::frac_bits()));
	}

	[[nodiscard]] constexpr explicit operator double() const {
		return this->inner * (1. / (1 << Fxp::frac_bits()));
	}

	[[nodiscard]] static constexpr std::size_t frac_bits() {
		if constexpr (std::IsSame<Inner, int32_t>::value) {
			return 16;
		} else if constexpr (std::IsSame<Inner, int64_t>::value) {
			return 32;
		}
	}
};

using I16F16 = Fxp<int32_t>;
using I32F32 = Fxp<int64_t>;

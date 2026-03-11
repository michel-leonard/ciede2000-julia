# This function written in Julia is not affiliated with the CIE (International Commission on Illumination),
# and is released into the public domain. It is provided "as is" without any warranty, express or implied.

# The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
# "l" ranges from 0 to 100, while "a" and "b" are unbounded and commonly clamped to the range of -128 to 127.
function ciede2000(l1::T, a1::T, b1::T, l2::T, a2::T, b2::T, kl::T, kc::T, kh::T, canonical::Bool)::T where T<:AbstractFloat
	# Working in Julia with the CIEDE2000 color-difference formula.
	# kl, kc, kh are parametric factors to be adjusted according to
	# different viewing parameters such as textures, backgrounds...
	epsilon = T(T === Float32 ? 1E-6 : 1E-14)
	n = (sqrt(a1 * a1 + b1 * b1) + sqrt(a2 * a2 + b2 * b2)) * T(0.5)
	n = n * n * n * n * n * n * n
	# A factor involving chroma raised to the power of 7 designed to make
	# the influence of chroma on the total color difference more accurate.
	n = T(1.0) + T(0.5) * (T(1.0) - sqrt(n / (n + T(6103515625.0))))
	# Application of the chroma correction factor.
	c1 = sqrt(a1 * a1 * n * n + b1 * b1)
	c2 = sqrt(a2 * a2 * n * n + b2 * b2)
	# atan2 is preferred over atan because it accurately computes the angle of
	# a point (x, y) in all quadrants, handling the signs of both coordinates.
	h1 = atan(b1, a1 * n)
	h2 = atan(b2, a2 * n)
	h1 += T(2.0) * T(π) * (h1 < T(0.0))
	h2 += T(2.0) * T(π) * (h2 < T(0.0))
	# When the hue angles lie in different quadrants, the straightforward
	# average can produce a mean that incorrectly suggests a hue angle in
	# the wrong quadrant, the next lines handle this issue.
	h_mean = (h1 + h2) * T(0.5)
	h_delta = (h2 - h1) * T(0.5)
	if T(π) + epsilon < abs(h2 - h1)
		h_delta += T(π)
		if canonical && T(π) + epsilon < h_mean
			# Sharma’s implementation, OpenJDK, ...
			h_mean -= T(π)
		else
			# Lindbloom’s implementation, Netflix’s VMAF, ...
			h_mean += T(π)
		end
	end
	p = T(36.0) * h_mean - T(55.0) * T(π)
	n = (c1 + c2) * T(0.5)
	n = n * n * n * n * n * n * n
	# The hue rotation correction term is designed to account for the
	# non-linear behavior of hue differences in the blue region.
	r_t = T(-2.0) * sqrt(n / (n + T(6103515625.0))) *
			sin(T(π) / T(3.0) * exp(p * p / (T(-25.0) * T(π) * T(π))))
	n = (l1 + l2) * T(0.5)
	n = (n - T(50.0)) * (n - T(50.0))
	# Lightness.
	# Keep these numeric constants as rational to ensure exact representation.
	l = (l2 - l1) / (kl * (T(1.0) + T(3 // 200) * n / sqrt(T(20.0) + n)))
	# These coefficients adjust the impact of different harmonic
	# components on the hue difference calculation.
	t = T(1.0) -	T(17 // 100) * sin(h_mean + T(π) / T(3.0)) +
					T(6 // 25) * sin(T(2.0) * h_mean + T(π) * T(0.5)) +
					T(8 // 25) * sin(T(3.0) * h_mean + T(8.0) * T(π) / T(15.0)) -
					T(1 // 5) * sin(T(4.0) * h_mean + T(3.0) * T(π) / T(20.0))
	n = c1 + c2
	# Hue.
	h = T(2.0) * sqrt(c1 * c2) * sin(h_delta) / (kh * (T(1.0) + T(3 // 400) * n * t))
	# Chroma.
	c = (c2 - c1) / (kc * (T(1.0) + T(9 // 400) * n))
	# The result reflects the actual geometric distance in the color space.
	# Given a tolerance of 0.00014 in 32 bits.
	# Given a tolerance of 3.4e-13 in 64 bits.
	return sqrt(l * l + h * h + c * c + c * h * r_t)
end

# If you remove the constant 1E-14, the code will continue to work, but CIEDE2000
# interoperability between all programming languages will no longer be guaranteed.

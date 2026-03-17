# CIEDE2000 color difference formula in Julia

This page presents the CIEDE2000 color difference, implemented in the Julia programming language.

![Logo](https://raw.githubusercontent.com/michel-leonard/ciede2000-color-matching/refs/heads/main/docs/assets/images/logo.jpg)

## Our CIEDE2000 offer

This production-ready file, released in 2026, contain the CIEDE2000 algorithm.

Source File|Type|Bits|Purpose|Advantage|
|:--:|:--:|:--:|:--:|:--:|
[ciede2000.jl](./ciede2000.jl)|`Float32`|32|General|Lightness, Speed|
[ciede2000.jl](./ciede2000.jl)|`Float64`|64|Scientific|Interoperability|
[ciede2000.jl](./ciede2000.jl)|`BigFloat`|Unlimited|Metrology|–|

### Software Versions

- Julia 1.X

### Example Usage

We calculate the CIEDE2000 distance between two colors, first without and then with parametric factors.

```julia
# Example of two L*a*b* colors
l1, a1, b1 = 59.2, 71.8, 5.1
l2, a2, b2 = 58.6, 94.1, -4.7

delta_e = ciede2000(l1, a1, b1, l2, a2, b2)
println("delta_e = $delta_e") # ΔE2000 = 6.045960283540082

# Example of parametric factors used in the dental industry
kl, kc, kh = 2.0, 1.0, 1.0

# Perform a CIEDE2000 calculation compliant with that of Gaurav Sharma
canonical = true

delta_e = ciede2000(l1, a1, b1, l2, a2, b2, kl, kc, kh, canonical)
println("delta_e = $delta_e") # ΔE2000 = 6.028085837133009
```

## Public Domain Licence

You are free to use these files, even for commercial purposes.

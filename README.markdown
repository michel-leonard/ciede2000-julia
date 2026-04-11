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

### Test Results

LEONARD’s tests are based on well-chosen L\*a\*b\* colors, with various parametric factors `kL`, `kC` and `kH`.

<details>
<summary>Display test results for 3 correct decimal places in Float32</summary>


```
CIEDE2000 Verification Summary :
          Compliance : [ ] CANONICAL [X] SIMPLIFIED
  First Checked Line : 40.0,0.5,-128.0,49.91,0.0,24.0,1.0,1.0,1.0,51.01867
           Precision : 3 decimal digits
           Successes : 10000000
               Error : 0
            Duration : 259.23 seconds
     Average Delta E : 63.58
   Average Deviation : 7.6e-06
   Maximum Deviation : 0.00016

```

```
CIEDE2000 Verification Summary :
          Compliance : [X] CANONICAL [ ] SIMPLIFIED
  First Checked Line : 40.0,0.5,-128.0,49.91,0.0,24.0,1.0,1.0,1.0,51.018467
           Precision : 3 decimal digits
           Successes : 10000000
               Error : 0
            Duration : 265.08 seconds
     Average Delta E : 63.58
   Average Deviation : 7.2e-06
   Maximum Deviation : 0.00019
```

</details>

<details>
<summary>Display test results for 12 correct decimal places in Float64</summary>

```
CIEDE2000 Verification Summary :
          Compliance : [ ] CANONICAL [X] SIMPLIFIED
  First Checked Line : 20.0,0.05,-30.0,30.0,0.0,128.0,1.0,1.0,1.0,53.41746217641311
           Precision : 12 decimal digits
           Successes : 100000000
               Error : 0
            Duration : 2521.37 seconds
     Average Delta E : 67.12
   Average Deviation : 5.7e-15
   Maximum Deviation : 3.1e-13
```

```
CIEDE2000 Verification Summary :
          Compliance : [X] CANONICAL [ ] SIMPLIFIED
  First Checked Line : 20.0,0.05,-30.0,30.0,0.0,128.0,1.0,1.0,1.0,53.417654165117426
           Precision : 12 decimal digits
           Successes : 100000000
               Error : 0
            Duration : 2536.18 seconds
     Average Delta E : 67.12
   Average Deviation : 6.1e-15
   Maximum Deviation : 3.1e-13
```

</details>

<details>
<summary>Display test results for 150 correct decimal places in BigFloat (512 bits)</summary>

```
CIEDE2000 Verification Summary :
          Compliance : [ ] CANONICAL [X] SIMPLIFIED
  First Checked Line : -0.0,8.0,32.0,0.0,32.00003,-128.0,1.0,1.0,1.0,52.95758888475620024850387...
           Precision : 150 decimal digits
           Successes : 100000000
               Error : 0
            Duration : 36556.56 seconds
     Average Delta E : 67.12
   Average Deviation : 9.3e-153
   Maximum Deviation : 1.9e-151
```

```
CIEDE2000 Verification Summary :
          Compliance : [X] CANONICAL [ ] SIMPLIFIED
  First Checked Line : -0.0,8.0,32.0,0.0,32.00003,-128.0,1.0,1.0,1.0,52.95739626510368628922817...
           Precision : 150 decimal digits
           Successes : 100000000
               Error : 0
            Duration : 34020.06 seconds
     Average Delta E : 67.12
   Average Deviation : 8.4e-153
   Maximum Deviation : 1.9e-151
```

</details>

## Public Domain Licence

You are free to use these files, even for commercial purposes.

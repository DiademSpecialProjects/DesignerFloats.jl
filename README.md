# FastFloats.jl
## An expansive interpretation of an evolving IEEE Standard. 
### Copyright 2024 by Jeffrey A. Sarnoff
##### For commercial use, contact <jeffrey.sarnoff@ieee.org>.
##### For non-commercial use, _provide attribution_ and tell me how you are using this material.
----

The abstract type for all FastFloats is `BinaryFloat`.

There are four concrete types of BinaryFloat. All have 1 Zero and 1 NaN.
- SignedFloat
  - signed values with infinities
- FiniteSignedFloat
  - signed values without infinities
- UnsignedFloat
  - unsigned (non-negative) values with infinity
- FiniteUnsignedFloat
  - unsigned (non-negative) values without infinity

Concrete types specify a Width (number of bits spanned by the representation) and a Precision (number of significant bits, includes the implicit bit).

- Widths of 3,4..15,16 are supported for all types.
- Precisions of 1..bitwidth-1 are supported for all types.

## Constructors

```
bitwidth  = 5
precision = 3

SFloat53  = SignedFLOAT(bitwidth, precision; inf=false)
SFloat53i = SignedFLOAT(bitwidth, precision; inf=true)

UFloat53n = UnsignedFLOAT(bitwidth, precision; inf=false, nan=true)
UFloat53i = UnsignedFLOAT(bitwidth, precision; inf=true, nan=false)
```

## Exported Functions
```
all_values(x::BinaryFLOAT)
- a vector of Rational + Float64 values in encoding order

all_encodings(x::BinaryFLOAT)
- a unit step vector of UInt8 or UInt16 values starting with 0
- the matching all_values vector
```

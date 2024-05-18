# FastFloats.jl
## An expansive interpretation of an evolving IEEE Standard. 
### Copyright 2024 by Jeffrey A. Sarnoff
##### For commercial use, contact <jeffrey.sarnoff@ieee.org>.
##### For non-commercial use, _provide attribution_ and tell me how you are using this material.
----

The abstract type for all FastFloats is `BinaryFloat`.

There are two general types of BinaryFloat, SignedFLOAT and UnsignedFLOAT.

Concrete types specify a Bitwdith (number of bits spanned by the representation) and a Precision (number of significand bits, including the implicit bit).

All concrete fast floats have a single Zero value, which is neither positive nor negative. SignedFLOATs always have a single NaN and they may have signed infinities. UnsignedFLOATs may have a single NaN and they may have a positive infinity.  

- Bitwidths of 3,4..15,16 are supported for both types.
- Precisions of 1..bitwidth are supported for both types.

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
all_values(x::BinaryFloat)
- a vector of Rational + Float64 values in encoding order

all_encodings(x::BinaryFloat)
- a unit step vector of UInt8 or UInt16 values starting with 0
- the matching all_values vector
```

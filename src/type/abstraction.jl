"""
     BinaryFloat{Width, Precision}

This is an abstract type, the subtype of AbstractFloat.

- All BinaryFloat formats encode one Zero value
    - Zero is neither positive nor negative 
    - there is no -0 value
    - when converting from a format with -0, -0 maps to 0

It is the immediate (and shared) supertype of 
SignedFloat and UnsignedFloat.

- Width is the storage width in bits.
- Precision is significand (with implicit bit) bitwidth. 
"""
abstract type BinaryFloat{W,P} <: AbstractFloat end

"""
     Width(x::BinaryFloat{W,P})

Width is a bit count: the storage width (memory spanned).
"""
Width(x::BinaryFloat{W,P}) = W

"""
     Precision(x::BinaryFloat{W,P})

Precision is a bit count of complete significand.
    - this includes the implicit bit
    - (0b1 for normal values, 0b0 for subnormals).

When realized, this the "significand".
"""
Precision(x::BinaryFloat{W,P}) = P

"""
    ExpBits(x::BinaryFloat{W,P})

ExpBits is the number of bits in the exponent field.
"""
ExpBits(x::BinaryFloat{W,P}) = W - Precision(x)

"""
     Significance(x::BinaryFloat{W,P})

This is explict significand field width in bits.
- by definition this is Precision - 1

When realized, this is the "trailing_significand".
"""
Significance(x::BinaryFloat{W,P}) = P - 1

# field value retreivals

"""
     inf(::BinaryFloat)

true iff the format encodes Inf
- UnsignedFloats may have +Inf, or not
- SignedFloats may have both +Inf and -Inf, or neither
"""
inf(x::BinaryFloat) = getfield(x, :inf)

"""
     nan(::BinaryFloat)

true iff the format encodes NaN
- UnsignedFloats may enode one NaN, or not
- SignedFloats **always** encode one NaN
"""
nan(x::BinaryFloat) = getfield(x, :nan)

#=
   concrete subtypes of BinaryFloat

- UnsigneFloat (encodes non-negative values)
- SignedFloat  (encodes non-negative and negative values)
=#

"""
    UnsignedFloat{Width, Precision}

All `UnsignedFloats` encode a single Zero value.
- Zero is neither positive nor negative.
- There is no -0. When converting, -0 is mapped to Zero.

- supertype is BinaryFloat{W,P} <: AbstractFloat
"""
Base.@kwdef struct UnsignedFloat{W,P} <: BinaryFloat{W,P}
    inf::Bool = false
    nan::Bool = true
end

"""
    SignedFloat{Width, Precision}

All `SignedFloats` encode a single Zero value.
- Zero is neither positive nor negative.
- There is no -0, When converting, -0 is mapped to Zero.

- supertype is BinaryFloat{W,P} <: AbstractFloat
"""
Base.@kwdef struct SignedFloat{W,P} <: BinaryFloat{W,P}
    inf::Bool = false
    nan::Bool = true
end

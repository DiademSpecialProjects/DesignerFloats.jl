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
Width(::Type{<:BinaryFloat{W,P}}) where {W,P} = W

"""
     Precision(x::BinaryFloat{W,P})

Precision is a bit count of complete significand.
    - this includes the implicit bit
    - (0b1 for normal values, 0b0 for subnormals).

When realized, this the "significand".
"""
Precision(::Type{<:BinaryFloat{W,P}}) where {W,P} = P

"""
    ExpBits(x::BinaryFloat{W,P})

ExpBits is the number of bits in the exponent field.
"""
ExpBits(::Type{<:BinaryFloat{W,P}}) where {W,P} = W - Precision(x)

"""
     Significance(x::BinaryFloat{W,P})

This is explict significand field width in bits.
- by definition this is Precision - 1

When realized, this is the "trailing_significand".
"""
Significance(::Type{<:BinaryFloat{W,P}}) where {W,P} = P - 1

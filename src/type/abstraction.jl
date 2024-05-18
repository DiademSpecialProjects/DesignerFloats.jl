"""
     BinaryFLOAT{Width, Precision}

This is an abstract type, the subtype of AbstractFloat.

- All BinaryFLOAT formats encode one Zero value
    - Zero is neither positive nor negative 
    - there is no -0 value
    - when converting from a format with -0, -0 maps to 0

It is the immediate (and shared) supertype of 
SignedFLOAT and UnsignedFLOAT.

- Width is the storage width in bits.
- Precision is significand (with implicit bit) bitwidth. 
"""
abstract type BinaryFLOAT{W,P} <: AbstractFloat end

"""
     Width(::BinaryFLOAT{W,P})

Width is a bit count: the storage width (memory spanned).
"""
Width(::Type{<:BinaryFLOAT{W,P}}) where {W,P} = W

"""
     Precision(::BinaryFLOAT{W,P})

Precision is a bit count of complete significand.
    - this includes the implicit bit
    - (0b1 for normal values, 0b0 for subnormals).

When realized, this the "significand".
"""
Precision(::Type{<:BinaryFLOAT{W,P}}) where {W,P} = P

"""
    ExpBias(x::BinaryFLOAT{W,P})

ExpBias is the offset applied to the raw exponent field.
"""
ExpBias(::Type{T}) where {W,P,T<:BinaryFLOAT{W,P}}  = (2^ExpBits(T) - 1) >> 1

"""
     TrailingSignificandBits(::BinaryFLOAT{W,P})

This is explict significand field width in bits.
- by definition this is Precision - 1

When realized, this is the "trailing_significand".
"""
TrailingSignificandBits(::Type{<:BinaryFLOAT{W,P}}) where {W,P} = P - 1

"""
    CountValues(::BinaryFLOAT{W,P})

counts the distinct values of x
- the number of encodings
"""
CountValues(::Type{<:BinaryFLOAT{W,P}}) where {W,P} = 2^W

"""
    CountExponents(::BinaryFLOAT{W,P})

counts the distinct exponent values
- the number of (biased) exponents
"""
CountExponents(::Type{T}) where {W,P,T<:BinaryFLOAT{W,P}} = 2^ExpBits(T)

"""
    CountSignificands(::BinaryFLOAT{W,P})

counts the significand values available 
- max(n_subnormal_signficands, n_normal_significands)
"""
CountSignificands(::Type{T}) where {W,P,T<:BinaryFLOAT{W,P}} =
    2^TrailingSignificandBits(T)


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
     SignedBinaryFloat{Width, Precision}

This is an abstract type, the subtype of BinaryFloat.

It is the immediate (and shared) supertype of 
SignedFloat and FiniteSignedFloat.

- Width is the storage width in bits.
- Precision is significand (with implicit bit) bitwidth. 
"""
abstract type SignedBinaryFloat{W,P} <: BinaryFloat{W,P} end


"""
     UnsignedBinaryFloat{Width, Precision}

This is an abstract type, the subtype of BinaryFloat.

It is the immediate (and shared) supertype of
UnsignedFloat and FiniteUnsignedFloat.

- Width is the storage width in bits.
- Precision is significand (with implicit bit) bitwidth. 
"""
abstract type UnsignedBinaryFloat{W,P} <: BinaryFloat{W,P} end

"""
     n_bits(::BinaryFloat{W,P})

n_bits is a bit count: the storage width (memory spanned).
"""
n_bits(::Type{<:BinaryFloat{W,P}}) where {W,P} = W

"""
     n_significant_bits(::BinaryFloat{W,P})

Precision is a bit count of complete significand.
    - this includes the implicit bit
    - (0b1 for normal values, 0b0 for subnormals).
"""
n_significant_bits(::Type{<:BinaryFloat{W,P}}) where {W,P} = P

"""
     n_trailing_bits(::BinaryFloat{W,P})

The trailing significand bits count the significand bits (those explicitly stored).
    - this excludes the implicit bit
"""
n_trailing_bits(::Type{<:BinaryFloat{W,P}}) where {W,P} = P - 1

"""
    n_values(::BinaryFloat{W,P})

counts the distinct values of x
- the number of encodings
"""
n_values(::Type{<:BinaryFloat{W,P}}) where {W,P} = 2^W

"""
    n_numeric_values(::BinaryFloat{W,P})

counts the distinct numeric values of x 
- excludes NaN
"""
n_numeric_values(::Type{<:BinaryFloat{W,P}}) where {W,P} = 2^W - 1

"""
    n_significands(::BinaryFloat{W,P})

counts the significand values available 
- max(n_subnormal_signficands, n_normal_significands)
"""
n_significands(::Type{<:BinaryFloat{W,P}}) where {W,P} =
    P == W ? 0 : 2^n_trailing_bits(T)

"""
    n_subnormal_significands(::BinaryFloat{W,P})

counts the subnormal significand values available 
"""
n_subnormal_significands(::Type{<:BinaryFloat{W,P}}) where {W,P} = 
    P == 1 ? 0 : (P == W ? 2^n_trailing_bits(T) : 2^n_trailing_bits(T) - 1)

"""
    n_exponent_bits(<: BinaryFloat{W,P})

counts the bits comprising the exponent field
"""
n_exponent_bits(::Type{<:SignedBinaryFloat{W,P}}) where {W,P} = W - P
n_exponent_bits(::Type{<:UnsignedBinaryFloat{W,P}}) where {W,P} = W - P + 1

"""
    n_exponent_values(<: BinaryFloat{W,P})

counts the individual values that the exponent may take
"""
n_exponent_values(T::Type{<:BinaryFloat{W,P}) where {W,P} = 2^n_exponent_bits(T)

"""
    exponent_bias(T::Type{<:BinaryFloat{W,P}) where {W,P} = 

exponent_bias is the offset applied to the raw exponent field.
""'
exponent_bias(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}  = (2^exponent_bits(T) - 1) >> 1

# for concrete types
     
n_bits(x::T) where {T<:BinaryFloat} = n_bits(T)
n_significant_bits(x::T) where {T<:BinaryFloat} = n_significant_bits(T)
n_trailing_bits(x::T) where {T<:BinaryFloat} = n_trailing_bits(T)
n_values(x::T) where {T<:BinaryFloat} = n_values(T)
n_significands(x::T) where {T<:BinaryFloat} = n_significands(T)
n_subnormal_significands(x::T) where {T<:BinaryFloat} = n_subnormal_significands(T)
n_exponent_bits(x::T) where {T<:BinaryFloat} = n_exponent_bits(T)
n_exponent_values(x::T) where {T<:BinaryFloat} = n_exponent_values(T)
exponent_bias(x::T) where {T<:BinaryFloat} = exponent_bias(T)


     

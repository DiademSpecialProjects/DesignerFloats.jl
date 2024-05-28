# counts

"""
     n_bits(::BinaryFloat{W,P})

n_bits is a bit count: the storage width (memory spanned).
"""
n_bits(::Type{<:BinaryFloat{W,P}}) where {W,P} = W
width(::Type{<:BinaryFloat{W,P}}) where {W,P} = W

"""
     n_significant_bits(::BinaryFloat{W,P})

Precision is a bit count of complete significand.
    - this includes the implicit bit
    - (0b1 for normal values, 0b0 for subnormals).
"""
n_significant_bits(::Type{<:BinaryFloat{W,P}}) where {W,P} = P
Base.precision(::Type{<:BinaryFloat{W,P}}) where {W,P} = P

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
n_significands(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    max(n_subnormal_significands(T), n_normal_significands(T))

"""
    n_significands(::BinaryFloat{W,P})

counts the normal significands
"""
n_normal_significands(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    P == W ? 0 : 2^n_trailing_bits(T)
   
"""
    n_subnormal_significands(::BinaryFloat{W,P})

counts the subnormal significand values available 
"""
n_subnormal_significands(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = 
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
n_exponent_values(T::Type{<:BinaryFloat{W,P}}) where {W,P} = 2^n_exponent_bits(T)

"""
    exponent_bias(T::Type{<:BinaryFloat{W,P}) where {W,P} = 

exponent_bias is the offset applied to the raw exponent field.
"""
exponent_bias(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}  = (2^exponent_bits(T) - 1) >> 1
  
n_special_values(::Type{T}) where {T<:UnsignedFloat} = 3 # 0, NaN, Inf
n_special_values(::Type{T}) where {T<:FiniteUnsignedFloat} = 2 # 0, NaN
n_special_values(::Type{T}) where {T<:SignedFloat} = 4 # 0, NaN, +/- Inf
n_special_values(::Type{T}) where {T<:FiniteSignedFloat} = 2 # 0, NaN

n_inf_values(::Type{T}) where {T<:UnsignedFloat} = 1
n_inf_values(::Type{T}) where {T<:FiniteUnsignedFloat} = 0
n_inf_values(::Type{T}) where {T<:SignedFloat} = 2
n_inf_values(::Type{T}) where {T<:FiniteSignedFloat} = 0

n_ordinary_values(::Type{T}) where {T<:BinaryFloat} = n_values(T) - n_special_values(T)
n_finite_values(::Type{T}) where {T<:BinaryFloat} = n_ordinary_values(T) + 1 # 0
n_numeric_values(::Type{T}) where {T<:BinaryFloat} = n_finite_values(T) + n_inf_values(T)

n_subnormal_values(::Type{T}) where {T<:BinaryFloat} = 2 * n_subnormal_significands(T)
n_normal_values(::Type{T}) where {T<:BinaryFloat} = n_ordinary_values(T) - n_subnormal_values(T)

n_finite_magnitudes(::Type{T}) where {T<:UnsignedFloat} = n_finite_values(T)
n_finite_magnitudes(::Type{T}) where {T<:FiniteUnsignedFloat} = n_finite_values(T)
n_finite_magnitudes(::Type{T}) where {T<:SignedFloat} = (n_finite_values(T) + 1) >> 1
n_finite_magnitudes(::Type{T}) where {T<:FiniteSignedFloat} = (n_finite_values(T) + 1) >> 1

n_magnitudes(::Type{T}) where {T<:BinaryFloat} = n_finite_magnitudes(T) + has_infinity(T)
n_numeric_magnitudes(::Type{T}) where {T<:BinaryFloat} = n_magnitudes(T)
n_ordinary_magnitudes(::Type{T}) where {T<:BinaryFloat} = n_finite_magnitudes(T) - 1 # Zero

n_subnormal_magnitudes(::Type{T}) where {T<:BinaryFloat} = n_subnormal_significands(T)
n_normal_magnitudes(::Type{T}) where {T<:BinaryFloat} = n_ordinary_magnitudes(T) - n_subnormal_magnitudes(T)

# for concrete types
     
width(x::T) where {T<:BinaryFloat} = n_bits(T)
Base.precision(x::T) where {T<:BinaryFloat} = Base.precision(T)
n_bits(x::T) where {T<:BinaryFloat} = n_bits(T)
n_significant_bits(x::T) where {T<:BinaryFloat} = n_significant_bits(T)
n_trailing_bits(x::T) where {T<:BinaryFloat} = n_trailing_bits(T)
n_values(x::T) where {T<:BinaryFloat} = n_values(T)
n_significands(x::T) where {T<:BinaryFloat} = n_significands(T)
n_normal_significands(x::T) where {T<:BinaryFloat} = n_normal_significands(T)
n_subnormal_significands(x::T) where {T<:BinaryFloat} = n_subnormal_significands(T)
n_exponent_bits(x::T) where {T<:BinaryFloat} = n_exponent_bits(T)
n_exponent_values(x::T) where {T<:BinaryFloat} = n_exponent_values(T)
exponent_bias(x::T) where {T<:BinaryFloat} = exponent_bias(T)

n_ordinary_values(x::T) where {T<:BinaryFloat} = n_ordinary_values(T)
n_finite_values(x::T) where {T<:BinaryFloat} = n_finite_values(T)
n_numeric_values(x::T) where {T<:BinaryFloat} = n_numeric_values(T)
n_subnormal_values(x::T) where {T<:BinaryFloat} = n_subnormal_values(T)
n_normal_values(x::T) where {T<:BinaryFloat} = n_normal_values(T)

n_ordinary_magnitudes(x::T) where {T<:BinaryFloat} = n_ordinary_magnitudes(T)
n_finite_magnitudes(x::T) where {T<:BinaryFloat} = n_finite_magnitudes(T)
n_numeric_magnitudes(x::T) where {T<:BinaryFloat} = n_numeric_magnitudes(T)
n_subnormal_magnitudes(x::T) where {T<:BinaryFloat} = n_subnormal_magnitudes(T)
n_normal_magnitudes(x::T) where {T<:BinaryFloat} = n_normal_magnitudes(T)


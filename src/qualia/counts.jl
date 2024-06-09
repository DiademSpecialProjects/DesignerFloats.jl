# counts

"""
     width(::BinaryFloat{W,P})

this is a bit count: the storage width (memory spanned).
- synonym for [`n_bits`](@ref)
"""
width(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = W

"""
    n_numeric_values(::BinaryFloat{W,P})

counts the distinct numeric values
- excludes NaN

see [`n_values`](@ref)
"""
n_numeric_values(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = n_values(T) - 1

"""
     n_significant_bits(::BinaryFloat{W,P})

Precision is a bit count of complete significand.
    - this includes the implicit bit
    - (0b1 for normal values, 0b0 for subnormals).

this is a synonym for `precision`.

see [`n_trailing_bits`](@ref)
"""
n_significant_bits(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = P
Base.precision(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = P

"""
     n_trailing_bits(::BinaryFloat{W,P})

The trailing significand bits count the significand bits (those explicitly stored).
    - this excludes the implicit bit

see [`n_significant_bits`](@ref)
"""
n_trailing_bits(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = P - 1

"""
    n_trailing_values(::BinaryFloat{W,P})

counts the distinct values available from the trailing_bits

see [`n_trailing_bits`](@ref)
"""
n_trailing_values(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = 2^n_trailing_bits(T)

"""
    n_significands(::BinaryFloat{W,P})

counts the significand values available 
- max(n_subnormal_significands, n_normal_significands)
"""
n_significands(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    max(n_subnormal_significands(T), n_normal_significands(T))

"""
    nmax_normal_significands(::BinaryFloat{W,P})

counts the maximum number of normal significands available

- a specific type may have fewer normal significands
"""
nmax_normal_significands(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    P == W ? 0 : 2^n_trailing_bits(T)

"""
    nmax_subnormal_significands(::BinaryFloat{W,P})

counts the maximum number subnormal significand values available 

- a specific type may have fewer subnormal significands
"""
nmax_subnormal_significands(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = 
    P == 1 ? 0 : (P == W ? 2^n_trailing_bits(T) : 2^n_trailing_bits(T) - 1)

"""
    n_normal_significands(::BinaryFloat{W,P})

counts the maximum number of normal significands
- a specific type may have fewer normal significands
"""
n_normal_significands(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    P == W ? 0 : 2^n_trailing_bits(T)

"""
    n_subnormal_significands(::BinaryFloat{W,P})

counts the subnormal significand values available 
"""
n_subnormal_significands(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = 
    P == 1 ? 0 : 2^n_trailing_bits(T) - 1

"""
    n_exponent_bits(<: BinaryFloat{W,P})

counts the bits comprising the exponent field
"""
n_exponent_bits(::Type{<:SignedBinaryFloat{W,P}}) where {W,P} = W - P
n_exponent_bits(::Type{<:UnsignedBinaryFloat{W,P}}) where {W,P} = W - P + 1


"""
    exponent_bias(T::Type{<:BinaryFloat{W,P}) where {W,P} = 

exponent_bias is the offset applied to the raw exponent field.
"""
Base.exponent_bias(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = (2^n_exponent_bits(T) - 1) >> 1

"""
    n_exponents(::BinaryFloat{W,P})

counts the exponent values available 
- max(n_subnormal_exponents, n_normal_exponents)
"""
n_exponents(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    max(n_subnormal_exponents(T), n_normal_exponents(T))

n_exponent_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    n_exponents(T)

"""
    n_normal_exponents(<: BinaryFloat{W,P})

counts the individual values that the exponent may take in normal values
"""
n_normal_exponents(T::Type{<:BinaryFloat{W,P}}) where {W,P} =
    P == W ? 0 : (is_signed(T) ? 2*max_exponent(T) + 1 : max_exponent(T) + 1)

n_normal_exponent_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    n_normal_exponents(T)

"""
    n_subnormal_exponents(<: BinaryFloat{W,P})

counts the individual values that the exponent may take in subnormal values
"""
n_subnormal_exponents(T::Type{<:BinaryFloat{W,P}}) where {W,P} =
    P == 1 ? 0 : 1

n_subnormal_exponent_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    n_subnormal_exponents(T)

n_special_values(::Type{T}) where {T<:UnsignedFloat} = 3 # 0, NaN, Inf
n_special_values(::Type{T}) where {T<:FiniteUnsignedFloat} = 2 # 0, NaN
n_special_values(::Type{T}) where {T<:SignedFloat} = 4 # 0, NaN, +/- Inf
n_special_values(::Type{T}) where {T<:FiniteSignedFloat} = 2 # 0, NaN

n_special_magnitudes(::Type{T}) where {T<:UnsignedFloat} = 2 # 0, Inf
n_special_magnitudes(::Type{T}) where {T<:FiniteUnsignedFloat} = 1 # 0
n_special_magnitudes(::Type{T}) where {T<:SignedFloat} = 2 # 0, Inf
n_special_magnitudes(::Type{T}) where {T<:FiniteSignedFloat} = 1 # 0

n_inf_values(::Type{T}) where {T<:UnsignedFloat} = 1
n_inf_values(::Type{T}) where {T<:FiniteUnsignedFloat} = 0
n_inf_values(::Type{T}) where {T<:SignedFloat} = 2
n_inf_values(::Type{T}) where {T<:FiniteSignedFloat} = 0

n_ordinary_values(::Type{T}) where {T<:BinaryFloat} = n_values(T) - n_special_values(T)
n_finite_values(::Type{T}) where {T<:BinaryFloat} = n_ordinary_values(T) + 1 # 0
n_numeric_values(::Type{T}) where {T<:BinaryFloat} = n_finite_values(T) + n_inf_values(T)

n_subnormal_values(::Type{T}) where {T<:BinaryFloat} = 2 * n_subnormal_significands(T)
n_normal_values(::Type{T}) where {T<:BinaryFloat} = n_ordinary_values(T) - n_subnormal_values(T)

n_finite_magnitudes(::Type{T}) where {T<:SimpleFloat} = n_finite_values(T)
n_finite_magnitudes(::Type{T}) where {T<:UnsignedFloat} = n_finite_values(T)
n_finite_magnitudes(::Type{T}) where {T<:FiniteUnsignedFloat} = n_finite_values(T)
n_finite_magnitudes(::Type{T}) where {T<:SignedFloat} = (n_finite_values(T) + 1) >> 1
n_finite_magnitudes(::Type{T}) where {T<:FiniteSignedFloat} = (n_finite_values(T) + 1) >> 1

n_magnitudes(::Type{T}) where {T<:SimpleFloat} = n_finite_values(T)
n_magnitudes(::Type{T}) where {T<:UnsignedFloat} = n_finite_values(T) + has_infinity(T)
n_magnitudes(::Type{T}) where {T<:FiniteUnsignedFloat} = n_finite_values(T)
n_magnitudes(::Type{T}) where {T<:SignedFloat} = (n_finite_values(T) + 1) >> 1 + has_infinity(T)
n_magnitudes(::Type{T}) where {T<:FiniteSignedFloat} = (n_finite_values(T) + 1) >> 1

n_numeric_magnitudes(::Type{T}) where {T<:BinaryFloat} = n_magnitudes(T)
n_ordinary_magnitudes(::Type{T}) where {T<:BinaryFloat} = n_finite_magnitudes(T) - 1 # Zero

n_subnormal_magnitudes(::Type{T}) where {T<:BinaryFloat} = n_subnormal_significands(T)
n_nonnegative_magnitudess(::Type{T}) where {T<:BinaryFloat} = 
n_normal_magnitudes(::Type{T}) where {T<:BinaryFloat} = n_ordinary_magnitudes(T) - n_subnormal_magnitudes(T)

# for concrete types

for F in (:width, :n_bits, :n_values, :n_significant_bits, :n_exponent_bits,
          :exponent_bias, :n_trailing_bits, :n_significands, 
          :nmax_normal_significands, :nmax_subnormal_significands, 
          :n_normal_significand_magnitudes, :n_subnormal_significand_magnitudes, 
          :n_normal_exponent_magnitudes, :n_subnormal_exponent_magnitudes,
          :n_normal_significands, :n_subnormal_significands,
          :n_normal_exponents, :n_subnormal_exponents,
          :n_finite_magnitudes, :n_numeric_magnitudes, :n_magnitudes,
          :n_ordinary_magnitudes, :n_subnormal_magnitudes, :n_normal_magnitudes,
          :n_special_values, :n_inf_values, 
          :n_subnormal_values, :n_normal_values, :n_ordinary_values,
          :n_finite_values)
    @eval $F(x::T) where {W,P,T<:BinaryFloat{W,P}} = $F(T)
end

Base.precision(x::T) where {T<:BinaryFloat} = Base.precision(T)



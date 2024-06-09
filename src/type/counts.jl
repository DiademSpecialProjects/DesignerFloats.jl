"""
     n_bits(::BinaryFloat{W,P})

n_bits is a bit count: the storage width (memory spanned).
"""
n_bits(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = W

"""
    n_values(::BinaryFloat{W,P})

counts the distinct values of x
- the number of encodings
"""
n_values(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = 2^W

"""
    n_nonnegative_values(::BinaryFloat{W,P})

counts the distinct nonnegative values of x
- the number of encodings
"""
n_nonnegative_values(::Type{T}) where {W,P,T<:UnsignedBinaryFloat{W,P}} =
    n_values(T) - n_nan_values(T) - (n_inf_values(T) >> 1)

n_nonnegative_values(::Type{T}) where {W,P,T<:SignedBinaryFloat{W,P}} =
    ((n_values(T) - n_nan_values(T)) >> 1) - (n_inf_values(T) >> 1)

"""
     n_significand_bits(::BinaryFloat{W,P})

Precision is a bit count of complete significand.
    - this includes the implicit bit
    - (0b1 for normal values, 0b0 for subnormals).

this is a synonym for `precision`.

see [`n_trailing_bits`](@ref)
"""
n_significand_bits(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = P
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

counts the trailing significand values (those explicitly stored).
    - this excludes the implicit bit
    - this includes 1.0

see [`n_trailing_bits`](@ref)
"""
n_trailing_values(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = 2^n_trailing_bits(T)

"""
     n_subnormal_trailing_values(::BinaryFloat{W,P})

counts the trailing significand values (those explicitly stored).
    - this excludes the implicit bit
    - this excludes 0.0

see [`n_trailing_values`](@ref)
"""
n_subnormal_trailing_values(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = max(0, n_trailing_values(T) - 1)

"""
    n_subnormal_trailing_significands(<: BinaryFloat{W,P})

counts the individual values that the trailing significand may take in subnormal values
"""
function n_subnormal_trailing_significands(T::Type{<:BinaryFloat{W,P}}) where {W,P}
    if P==W
        max(0, n_subnormal_values(T))
    elseif isone(P)
        n_subnormal_values(T)
    elseif P == 2
        1
    else
        max(0, n_trailing_values(T) - 1)
    end
end
n_subnormal_significands = n_subnormal_trailing_significands

"""
    n_normal_trailing_significands(<: BinaryFloat{W,P})

counts the individual values that the trailing significand may take in normal values
"""
function n_normal_trailing_significands(T::Type{<:BinaryFloat{W,P}}) where {W,P}
    if isone(P)
        1
    elseif W == P
        0
    else
        n_trailing_values(T)
    end
end

"""
    n_exponent_bits(<: BinaryFloat{W,P})

counts the bits comprising the exponent field
"""
n_exponent_bits(::Type{T}) where {W, P, T<:SignedBinaryFloat{W,P}} = W - P
n_exponent_bits(::Type{T}) where {W, P, T<:UnsignedBinaryFloat{W,P}} = W - P + 1

"""
   n_exponent_values(<: BinaryFloat{W,P})

counts the exponent values
"""
n_exponent_values(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = 2^n_exponent_bits(T)

"""
    exponent_bias(T::Type{<:BinaryFloat{W,P}) where {W,P} = 

exponent_bias is the offset applied to the raw exponent field.
"""
Base.exponent_bias(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = (2^n_exponent_bits(T) - 1) >> 1

"""
    n_subnormal_exponents(<: BinaryFloat{W,P})

counts the individual values that the exponent may take in subnormal values
"""
n_subnormal_exponents(T::Type{<:BinaryFloat{W,P}}) where {W,P} =
    P == 1 ? 0 : 1

"""
    n_subnormal_exponents(<: BinaryFloat{W,P})

counts the individual values that the exponent may take in subnormal values
"""
function n_normal_exponents(T::Type{<:BinaryFloat{W,P}}) where {W,P}
    if P == W
        0
    elseif isone(P)
        n_exponent_values(T)
    else
        n_exponent_values(T) - 1
    end
end

n_special_values(::Type{T}) where {T<:UnsignedFloat} = 3 # 0, NaN, Inf
n_special_values(::Type{T}) where {T<:FiniteUnsignedFloat} = 2 # 0, NaN
n_special_values(::Type{T}) where {T<:SimpleFloat} = 1 # 0
n_special_values(::Type{T}) where {T<:SignedFloat} = 4 # 0, NaN, +/- Inf
n_special_values(::Type{T}) where {T<:FiniteSignedFloat} = 2 # 0, NaN

n_special_magnitudes(::Type{T}) where {T<:UnsignedFloat} = 2 # 0, Inf
n_special_magnitudes(::Type{T}) where {T<:FiniteUnsignedFloat} = 1 # 0
n_special_magnitudes(::Type{T}) where {T<:SimpleFloat} = 1 # 0
n_special_magnitudes(::Type{T}) where {T<:SignedFloat} = 2 # 0, Inf
n_special_magnitudes(::Type{T}) where {T<:FiniteSignedFloat} = 1 # 0

n_inf_magnitudes(::Type{T}) where {T<:UnsignedFloat} = 1
n_inf_magnitudes(::Type{T}) where {T<:FiniteUnsignedFloat} = 0
n_inf_magnitudes(::Type{T}) where {T<:SimpleFloat} = 0
n_inf_magnitudes(::Type{T}) where {T<:SignedFloat} = 1
n_inf_magnitudes(::Type{T}) where {T<:FiniteSignedFloat} = 0

n_inf_values(::Type{T}) where {T<:UnsignedFloat} = 1
n_inf_values(::Type{T}) where {T<:FiniteUnsignedFloat} = 0
n_inf_values(::Type{T}) where {T<:SimpleFloat} = 0
n_inf_values(::Type{T}) where {T<:SignedFloat} = 2
n_inf_values(::Type{T}) where {T<:FiniteSignedFloat} = 0

n_nan_values(::Type{T}) where {T<:UnsignedFloat} = 1
n_nan_values(::Type{T}) where {T<:FiniteUnsignedFloat} = 1
n_nan_values(::Type{T}) where {T<:SimpleFloat} = 0
n_nan_values(::Type{T}) where {T<:SignedFloat} = 1
n_nan_values(::Type{T}) where {T<:FiniteSignedFloat} = 1

function n_subnormal_magnitudes(::Type{T}) where {W, P, T<:BinaryFloat{W,P}}
    if P==1
        0
    elseif P==W
        n_ordinary_magnitudes(T)
    else
        n_subnormal_trailing_significands(T)
    end    
end

function n_normal_magnitudes(::Type{T}) where {W, P, T<:BinaryFloat{W,P}}
    n_ordinary_magnitudes(T) - n_subnormal_magnitudes(T)
end

function n_magnitudes(::Type{T}) where {W, P, T<:BinaryFloat{W,P}}
    n = n_values(T) - n_nan_values(T)
    if is_signed(T)
        n = n >> 1
    end
end

function n_ordinary_magnitudes(::Type{T}) where {W, P, T<:BinaryFloat{W,P}}
    n = n_values(T) - n_nan_values(T)
    if is_signed(T)
        n = n >> 1
    end
    n - 1 - has_infinity(T)
end

function n_finite_magnitudes(::Type{T}) where {W, P, T<:BinaryFloat{W,P}}
    n_ordinary_magnitudes(T) + 1 # for Zero
end

function n_nonzero_magnitudes(::Type{T}) where {W, P, T<:BinaryFloat{W,P}}
    n_finite_magnitudes + has_infinity(T)
end

n_subnormal_values(::Type{T}) where {W, P, T<:BinaryFloat{W,P}} =
    W==P ? n_nonnegative_values(T) : max(0, n_subnormal_trailing_significands(T))

max_n_normal_values(::Type{T}) where {W, P, T<:BinaryFloat{W,P}} =
    n_normal_trailing_significands(T) * n_normal_exponents(T)

n_normal_values(::Type{T}) where {W, P, T<:BinaryFloat{W,P}} =
    max(0, max_n_normal_values(T) - n_subnormal_values(T))



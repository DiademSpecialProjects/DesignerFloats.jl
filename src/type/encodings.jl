function all_encodings(::Type{T}) where {W, P, T<:BinaryFloat{W,P}}
    n = n_values(T)
    max_encoding = n - 1
    collect(Encoding(0):Encoding(max_encoding))
end

min_encoding(::Type{T}) where {W, P, T<:BinaryFloat{W,P}} =
    Encoding(0)

max_encoding(::Type{T}) where {W, P, T<:BinaryFloat{W,P}} =
    Encoding(n_values(T) - 1)

"""
    ConstEncodings

_ConstEncodings are invariant over BinaryFloats_

zero(T<:BinaryFloat) is encoded `zero(Encoding)`

the smallest non-zero magnitude in T is encoded `one(Encoding)`
- if subnormals exist in T, this is the subnormal value of least magnitude
- otherwise, this is the normal value of least magnitude

see [`StableEncodings`](@ref)
""" ConstEncodings

encodes_zero(::Type{T}) where {W, P, T<:BinaryFloat{W,P}} = Encoding(0)
encodes_tiny_float(::Type{T}) where {W, P, T<:BinaryFloat{W,P}} = Encoding(1)

"""
    StableEncodings

_StableEncodings are fully determined and simply given over BinaryFloats_
- a StableEncoding may be `nothing`, `encodes_inf(T) where !has_infinity(T)`

-`encodes_min_subnormal`
-`encodes_max_subnormal`
-`encodes_min_normal`
-`encodes_max_normal` (`encodes_max_float` is a synonym)
-`encodes_inf` (`encodes_posinf` is a synonym)

-`encodes_min_neg_subnormal`
-`encodes_max_neg_subnormal`
-`encodes_min_neg_normal`
-`encodes_max_neg_normal` (`encodes_max_neg_float` is a synonym)
-`encodes_neginf`

-`encodes_nan`

see [`ConstEncodings`](@ref)
""" StableEncodings

function encodes_min_subnormal(::Type{T}) where {W, P, T<:BinaryFloat{W,P}}
    n = n_subnormal_magnitudes(T)
    if !iszero(n)
        one(Encoding)
    else
        nothing
    end
end

function encodes_max_subnormal(::Type{T}) where {W, P, T<:BinaryFloat{W,P}}
    n = n_subnormal_magnitudes(T)
    if !iszero(n)
        Encoding(n)
    else
        nothing
    end
end

function encodes_min_normal(::Type{T}) where {W, P, T<:BinaryFloat{W,P}}
    n = n_normal_magnitudes(T)
    if !iszero(n)
        Encoding(n_subnormal_magnitudes(T) + one(Encoding))
    else
        nothing
    end
end

function encodes_max_normal(::Type{T}) where {W, P, T<:BinaryFloat{W,P}}
    n = n_normal_magnitudes(T)
    if !iszero(n)
        Encoding(n_subnormal_magnitudes(T) + n_normal_magnitudes(T))
    else
        nothing
    end
end

encodes_max_float = encodes_max_normal

function encodes_min_neg_subnormal(::Type{T}) where {W, P, T<:BinaryFloat{W,P}}
    n = n_subnormal_magnitudes(T)
    if !iszero(n)
        Encoding((n_values(T) >> 1) + one(Encoding))
    else
        nothing
    end
end

function encodes_max_neg_subnormal(::Type{T}) where {W, P, T<:BinaryFloat{W,P}}
    n = n_subnormal_magnitudes(T)
    if !iszero(n)
        Encoding((n_values(T) >> 1) + Encoding(n))
    else
        nothing
    end
end

function encodes_min_neg_normal(::Type{T}) where {W, P, T<:BinaryFloat{W,P}}
    n = n_normal_magnitudes(T)
    if !iszero(n)
        Encoding(encodes_max_neg_subnormal(T) + one(Encoding))
    else
        nothing
    end
end

function encodes_max_neg_normal(::Type{T}) where {W, P, T<:BinaryFloat{W,P}}
    n = n_normal_magnitudes(T)
    if !iszero(n)
        Encoding(encodes_max_neg_subnormal(T) + n_normal_magnitudes(T))
    else
        nothing
    end
end

encodes_max_neg_float = encodes_max_neg_normal

function encodes_inf(::Type{T}) where {W, P, T<:BinaryFloat{W,P}}
    if has_infinity(T)
        Encoding(encodes_max_normal(T) + one(Encoding))
    else
        nothing
    end
end
encodes_posinf = encodes_infs

function encodes_neginf(::Type{T}) where {W, P, T<:BinaryFloat{W,P}}
    if is_signed(T) && has_infinity(T)
        Encoding(n_values(T) - one(Encoding))
    else
        nothing
    end
end

function encodes_nan(::Type{T}) where {W, P, T<:BinaryFloat{W,P}}
    if has_nan(T)
        if has_infinity(T)
            Encoding(encodes_inf(T) + one(Encoding))
        else
            Encoding(encodes_max_normal(T) + one(Encoding))
        end
    else
        nothing
    end

for F in (:all_encodings, :min_encoding, :max_encoding, 
          :encodes_zero, :encodes_tiny_float,
          :encodes_min_subnormal, :encodes_max_subnormal,
          :encodes_min_normal, :encodes_max_normal, :encodes_max_float,
          :encodes_inf, :encodes_posinf,
          :encodes_min_neg_subnormal, :encodes_max_neg_subnormal,
          :encodes_min_neg_normal, :encodes_max_neg_normal, :encodes_max_neg_float,
          :encodes_neginf, :encodes_nan)
    @eval $F(x::T) where {W, P, T<:BinaryFloat{W,P}} =
          $F(T)
end


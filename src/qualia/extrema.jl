#=
    obtain the extremal magnitudes for subnormal and normal
        (unbiased) exponents
        significands
=#

function simple_values(minval, maxval)
    (isnothing(minval) && isnothing(maxval)) && return copy(NoValues)
    isnothing(maxval)  && return Real[minval]
    isnothing(minval)  && return Real[maxval]
    
    if isequal(minval, maxval)
        Real[minval]
    else
        Real[minval, maxval]
    end
end

min_biased_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P} = 0
max_biased_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P} = 2^n_exponent_bits(T) - 1

min_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P} = min_biased_exponent(T)-exponent_bias(T)
max_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P} = max_biased_exponent(T)-exponent_bias(T)

function min_subnormal_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}
    n = n_subnormal_exponents(T)
    iszero(n) && return nothing
    2.0^min_exponent(T)
end

max_subnormal_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P} =
    min_subnormal_exponent(T)

function minmax_subnormal_exponents(::Type{T}) where {W,P,T<:BinaryFloat{W,P}
    n = n_subnormal_exponents(T)
    iszero(n) && return copy(NoValues)
    simple_values(min_subnormal_exponent(T), max_subnormal_exponent(T))
end

function subnormal_exponent_range (::Type{T}) where {W,P,T<:BinaryFloat{W,P}
    n = n_subnormal_exponents(T)
    iszero(n) && return 1:0
    UnitRange(minmax_subnormal_exponents(T)...)
end

function min_normal_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P} 
    n = n_normal_exponents(T)
    iszero(n) && return nothing
    2.0^min_exponent(T)
end

function max_normal_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P} 
    n = n_normal_exponents(T)
    iszero(n) && return nothing
    2.0^max_exponent(T)
end

function minmax_normal_exponents(::Type{T}) where {W,P,T<:BinaryFloat{W,P}
    n = n_normal_exponents(T)
    iszero(n) && return copy(NoValues)
    simple_values(min_normal_exponent(T), max_normal_exponent(T))
end

function normal_exponent_range (::Type{T}) where {W,P,T<:BinaryFloat{W,P}
    n = n_normal_exponents(T)
    iszero(n) && return 1:0
    UnitRange(minmax_normal_exponents(T)...)
end




function extremal_subnormal_significands(x::BinaryFLOAT{W,P}) where {W,P}
    n = n_subnormal_significands(x)
    iszero(n) && return copy(NoValues)
    simple_values(min_subnormal_significand(x), max_subnormal_significand(x))
end

function extremal_normal_significands(x::BinaryFLOAT{W,P}) where {W,P}
    n = n_normal_significands(x)
    iszero(n) && return copy(NoValues)
    simple_values(min_normal_significand(x), max_normal_significand(x))
end

function min_subnormal_exponent_value(x::BinaryFLOAT{W,P}) where {W,P}
    n = n_subnormal_exponents(x)
    iszero(n) && return nothing
    raw = min_subnormal_exponent(x)
    RationalNK(2.0^raw)
end

function max_subnormal_exponent_value(x::BinaryFLOAT{W,P}) where {W,P}
    n = n_subnormal_exponents(x)
    iszero(n) && return nothing
    isone(n)  && return min_subnormal_exponent_value(x)

    error("Should Not Be Reached (n==$(n))")
end

function min_normal_exponent_value(x::BinaryFLOAT{W,P}) where {W,P}
    n = n_normal_exponents(x)
    iszero(n) && return nothing
    raw = min_normal_exponent(x)
    RationalNK(Two^raw)
end

function max_normal_exponent_value(x::BinaryFLOAT{W,P}) where {W,P}
    n = n_normal_exponents(x)
    iszero(n) && return nothing
    isone(n)  && return min_normal_exponent_value(x)
    raw = max_normal_exponent(x)
    RationalNK(Two^raw)
end

function min_subnormal_exponent(x::BinaryFLOAT{W,P}) where {W,P}
    n = n_subnormal_exponents(x)
    iszero(n) && return nothing
    0 - ExpBias(x)
end

function max_subnormal_exponent(x::BinaryFLOAT{W,P}) where {W,P}
    n = n_subnormal_exponents(x)
    iszero(n) && return nothing
    isone(n)  && return min_subnormal_exponent(x)

    error("Should Not Be Reached (n==$(n))")
end

function min_normal_exponent(x::BinaryFLOAT{W,P}) where {W,P}
    n = n_normal_exponents(x)
    iszero(n) && return nothing
    -ExpBias(x) # constrast with 754, which results from having many NaNs
end

function max_normal_exponent(x::BinaryFLOAT{W,P}) where {W,P}
    n = n_normal_exponents(x)
    iszero(n) && return nothing
    isone(n) && return min_normal_exponent(x)
    ExpBias(x) # constrast with 754, which results from having many NaNs
end

function min_normal_raw_exponent(x::BinaryFLOAT{W,P}) where {W,P}
    n = n_normal_exponents(x)
    iszero(n) && return nothing
    PosOne # 0 - ExpBias(x)
end

function max_normal_raw_exponent(x::BinaryFLOAT{W,P}) where {W,P}
    n = n_normal_exponents(x)
    iszero(n) && return nothing
    isone(n)  && return min_normal_exponent(x)
    Zero + n
end

function min_subnormal_significand(x::BinaryFLOAT{W,P}) where {W,P}
    n = n_subnormal_significands(x)
    iszero(n) && return nothing
    RationalNK(1, CountSignificands(x))
end

function max_subnormal_significand(x::BinaryFLOAT{W,P}) where {W,P}
    n = n_subnormal_significands(x)
    iszero(n) && return nothing
    isone(n)  && return min_subnormal_significand(x)
    RationalNK(CountSignificands(x) - 1, CountSignificands(x))
end

function min_normal_significand(x::BinaryFLOAT{W,P}) where {W,P}
    n = n_normal_significands(x)
    iszero(n) && return nothing
    PosOne
end

function max_normal_significand(x::BinaryFLOAT{W,P}) where {W,P}
    n = n_normal_significands(x)
    iszero(n) && return nothing
    isone(n) && return min_normal_significand(x)
    PosOne + RationalNK(CountSignificands(x) - 1, CountSignificands(x))
end

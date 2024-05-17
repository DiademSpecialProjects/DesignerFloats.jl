#=
    obtain the extremal magnitudes for subnormal and normal
        (unbiased) exponents
        significands
=#

function simple_values(minval, maxval)
    (isnothing(minval) && isnothing(maxval)) && return copy(NoValues)
    isnothing(maxval)  && return ValType[minval]
    isnothing(minval)  && return ValType[maxval]
    
    if isequal(minval, maxval)
        ValType[minval]
    else
        ValType[minval, maxval]
    end
end

function extremal_subnormal_exponent_values(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_exponents(x)
    iszero(n) && return copy(NoValues)
    simple_values(min_subnormal_exponent_value(x), max_subnormal_exponent_value(x))
end

function extremal_normal_exponent_values(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_exponents(x)
    iszero(n) && return copy(NoValues)
    simple_values(min_normal_exponent_value(x), max_normal_exponent_value(x))
end

function extremal_subnormal_exponents(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_exponents(x)
    iszero(n) && return copy(NoValues)
    simple_values(min_subnormal_exponent(x), max_subnormal_exponent(x))
end

function extremal_normal_exponents(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_exponents(x)
    iszero(n) && return copy(NoValues)
    simple_values(min_normal_exponent(x), max_normal_exponent(x))
end

function extremal_subnormal_significands(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_significands(x)
    iszero(n) && return copy(NoValues)
    simple_values(min_subnormal_significand(x), max_subnormal_significand(x))
end

function extremal_normal_significands(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_significands(x)
    iszero(n) && return copy(NoValues)
    simple_values(min_normal_significand(x), max_normal_significand(x))
end

function min_subnormal_exponent_value(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_exponents(x)
    iszero(n) && return nothing
    raw = min_subnormal_exponent(x)
    RationalNK(2.0^raw)
end

function max_subnormal_exponent_value(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_exponents(x)
    iszero(n) && return nothing
    isone(n)  && return min_subnormal_exponent_value(x)

    error("Should Not Be Reached (n==$(n))")
end

function min_normal_exponent_value(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_exponents(x)
    iszero(n) && return nothing
    raw = min_normal_exponent(x)
    RationalNK(Two^raw)
end

function max_normal_exponent_value(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_exponents(x)
    iszero(n) && return nothing
    isone(n)  && return min_normal_exponent_value(x)
    raw = max_normal_exponent(x)
    RationalNK(Two^raw)
end

function min_subnormal_exponent(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_exponents(x)
    iszero(n) && return nothing
    0 - ExpBias(x)
end

function max_subnormal_exponent(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_exponents(x)
    iszero(n) && return nothing
    isone(n)  && return min_subnormal_exponent(x)

    error("Should Not Be Reached (n==$(n))")
end

function min_normal_exponent(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_exponents(x)
    iszero(n) && return nothing
    0 - ExpBias(x)
end

function max_normal_exponent(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_exponents(x)
    iszero(n) && return nothing
    isone(n)  && return min_normal_exponent(x)
    ExpBias(x)
end

function min_subnormal_significand(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_significands(x)
    iszero(n) && return nothing
    RationalNK(1, CountSignificands(x))
end

function max_subnormal_significand(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_significands(x)
    iszero(n) && return nothing
    isone(n)  && return min_subnormal_significand(x)
    RationalNK(CountSignificands(x) - 1, CountSignificands(x))
end

function min_normal_significand(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_significands(x)
    iszero(n) && return nothing
    PosOne
end

function max_normal_significand(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_significands(x)
    iszero(n) && return nothing
    isone(n) && return min_normal_significand(x)
    PosOne + RationalNK(CountSignificands(x) - 1, CountSignificands(x))
end

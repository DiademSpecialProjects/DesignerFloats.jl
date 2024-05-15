#=
    obtain the extremal magnitudes for subnormal and normal
        (unbiased) exponents
        signficands
=#

function simple_values(minval, maxval)
    (isnothing(minval) && isnothing(maxval)) && return NoValues
    isnothing(maxval)  && return ValType[minval]
    isnothing(minval)  && return ValType[maxval]
    
    if isequal(minval, maxval)
        ValType[minval]
    else
        ValType[minval, maxval]
    end
end

function extremal_subnormal_exponents(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_exponents(x)
    iszero(n) && return NoValues
    simple_values(min_subnormal_exponent(x), max_subnormal_exponent(x))
end

function extremal_normal_exponents(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_exponents(x)
    iszero(n) && return NoValues
    simple_values(min_normal_exponent(x), max_normal_exponent(x))
end

function extremal_subnormal_significands(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_significands(x)
    iszero(n) && return NoValues
    simple_values(min_subnormal_significand(x), max_subnormal_significand(x))
end

function extremal_normal_significands(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_significands(x)
    iszero(n) && return NoValues
    simple_values(min_normal_significand(x), max_normal_significand(x))
end

function min_subnormal_exponent(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_exponents(x)
    iszero(n) && return nothing
    0 - ExpBias(x)
end

function max_subnormal_exponent(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_exponents(x)
    iszero(n) && return nothing
    ExpBias(x) - 1
end

function min_normal_exponent(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_exponents(x)
    iszero(n) && return nothing
    0 - ExpBias(x)
end

function max_normal_exponent(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_exponents(x)
    iszero(n) && return nothing
    ExpBias(x)
end

function min_subnormal_significand(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_significands(x)
    iszero(n) && return nothing
    RationalNK(1, CountSignificances(x))
end

function max_subnormal_significand(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_significands(x)
    iszero(n) && return nothing
    RationalNK(CountSignificances(x) - 1, CountSignificances(x))
end

function min_normal_significand(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_significands(x)
    iszero(n) && return nothing
    PosOne
end

function max_normal_significand(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_significands(x)
    iszero(n) && return nothing
    PosOne + RationalNK(CountSignificances(x) - 1, CountSignificances(x))
end

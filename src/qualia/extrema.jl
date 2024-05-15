#=
    obtain the extremal magnitudes for subnormal and normal
        (unbiased) exponents
        signficands
=#

function extremal_subnormal_exponents(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_exponents(x)
    iszero(n) && return NoValues
    isone(n)  && return ValTypes[min_subnormal_exponent(x)]

    mn, mx = min_subnormal_exponent(x), max_subnormal_exponent(x)
    if isequal(mn, mx)
        ValType[mn]
    else
        ValType[mn, mx]
    end
end

function extremal_normal_exponents(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_exponents(x)
    iszero(n) && return NoValues
    isone(n) && return ValTypes[min_normal_exponent(x)]

    mn, mx = min_normal_exponent(x), max_normal_exponent(x)
    if isequal(mn, mx)
        ValType[mn]
    else
        ValType[mn, mx]
    end
end

function extremal_subnormal_significands(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_significands(x)
    iszero(n) && return NoValues
    isone(n) && return ValTypes[min_subnormal_significand(x)]

    mn, mx = min_subnormal_significand(x), max_subnormal_significand(x)
    if isequal(mn, mx)
        ValType[mn]
    else
        ValType[mn, mx]
    end
end

function extremal_normal_significands(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_significands(x)
    iszero(n) && return NoValues
    isone(n) && return ValTypes[min_normal_significand(x)]

    mn, mx = min_normal_significand(x), max_normal_significand(x)
    if isequal(mn, mx)
        ValType[mn]
    else
        ValType[mn, mx]
    end
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
    RationalNK(n, n+1)
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

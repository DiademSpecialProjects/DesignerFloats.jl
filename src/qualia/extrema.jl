#=
    obtain the extremal magnitudes for subnormal and normal
        (unbiased) exponents
        signficands
=#

function extremal_subnormal_exponents(x::BinaryFloat{K,P}) where {K,P}
    n = n_subnormal_exponents(x)
    iszero(n) && return NoValues
    mn, mx = min_normal_exponent(x), max_normal_exponent(x)
    if isequal(mn, mx)
        ValType[mn]
    else
        ValType[mn, mx]
    end
end

function extremal_normal_exponents(x::BinaryFloat{K,P}) where {K,P}
    n = n_normal_exponents(x)
    iszero(n) && return NoValues
    mn, mx = min_normal_exponent(x), max_normal_exponent(x)
    if isequal(mn, mx)
        ValType[mn]
    else
        ValType[mn, mx]
    end
end

function extremal_subnormal_significands(x::BinaryFloat{K,P}) where {K,P}
    n = n_subnormal_significands(x)
    iszero(n) && return NoValues
    mn, mx = min_subnormal_significand(x), max_subnormal_significand(x)
    if isequal(mn, mx)
        ValType[mn]
    else
        ValType[mn, mx]
    end
end

function extremal_normal_significands(x::BinaryFloat{K,P}) where {K,P}
    n = n_normal_significands(x)
    iszero(n) && return NoValues
    mn, mx = min_normal_significand(x), max_normal_significand(x)
    if isequal(mn, mx)
        ValType[mn]
    else
        ValType[mn, mx]
    end
end


function subnormal_exponent_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_exponents(x)
    iszero(n) && return NoValues
    isone(n)  && return ValType[min_subnormal_exponent(x)]

    mn, mx = extremal_subnormal_significands(x)
    mn2mx = range(start=mn, stop=mx, length=n)
    ValType[collect(mn2mx)...]
end

function normal_exponent_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_exponents(x)
    iszero(n) && return NoValues
    isone(n) && return ValType[min_normal_significand(x)]

    mn, mx = extremal_subnormal_significands(x)
    mn2mx = range(start=mn, stop=mx, length=n)
    ValType[collect(mn2mx)...]
end

function subnormal_significand_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_significands(x)
    iszero(n) && return NoValues
    isone(n) && return ValType[min_subnormal_significand(x)]

    mn, mx = extremal_subnormal_significands(x)
    mn2mx = range(start=mn, stop=mx, length=n)
    ValType[collect(mn2mx)...]
end

function normal_significand_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_significands(x)
    iszero(n) && return NoValues
    isone(n) && return ValType[min_normal_significand(x)]

    mn, mx = extremal_subnormal_significands(x)
    mn2mx = range(start=mn, stop=mx, length=n)
    ValType[collect(mn2mx)...]
end




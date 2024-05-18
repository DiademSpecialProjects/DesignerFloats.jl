function magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_magnitudes(x)
    iszero(n) && return copy(NoValues)
    mags = finite_magnitudes(x)
    inf(x) && push!(mags, Inf)
    mags
end

function significand_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_magnitudes(x)
    iszero(n) && return copy(NoValues)
    mags = finite_significand_magnitudes(x)
    inf(x) && push!(mags, Inf)
    mags
end

function finite_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_finite_magnitudes(x)
    iszero(n) && return copy(NoValues)
    mags = admissable_finite_magnitudes(x)
    nextra = length(mags) - n
    while nextra > 0
        nextra -= 1
        pop!(mags)
    end
    mags
end

function finite_significand_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_finite_magnitudes(x)
    iszero(n) && return copy(NoValues)
    mags = admissable_finite_significand_magnitudes(x)
    nextra = length(mags) - n
    while nextra > 0
        nextra -= 1
        pop!(mags)
    end
    mags
end

function ordinary_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_ordinary_magnitudes(x)
    iszero(n) && return copy(NoValues)
    mags = admissable_ordinary_magnitudes(x)
    nextra = length(mags) - n
    while nextra > 0
        nextra -= 1
        pop!(mags)
    end
    mags
end

function ordinary_significand_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_ordinary_magnitudes(x)
    iszero(n) && return copy(NoValues)
    mags = admissable_ordinary_significand_magnitudes(x)
    nextra = length(mags) - n
    while nextra > 0
        nextra -= 1
        pop!(mags)
    end
    mags
end

function admissable_finite_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_finite_magnitudes(x)
    iszero(n) && return copy(NoValues)
    mags = admissable_ordinary_magnitudes(x)
    pushfirst!(mags, Zero)
    mags
end

function admissable_finite_significand_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_finite_magnitudes(x)
    iszero(n) && return copy(NoValues)
    mags = admissable_ordinary_significand_magnitudes(x)
    pushfirst!(mags, Zero)
    mags
end

function admissable_ordinary_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_magnitudes(x)
    iszero(n) && return copy(NoValues)
    vcat(subnormal_magnitudes(x), admissable_normal_magnitudes(x))
end

function admissable_ordinary_significand_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_magnitudes(x)
    iszero(n) && return copy(NoValues)
    vcat(subnormal_significand_magnitudes(x), admissable_normal_significand_magnitudes(x))
end

function subnormal_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_magnitudes(x)
    iszero(n) && return copy(NoValues)
    xps = range(extremal_subnormal_exponent_values(x)..., length=n_subnormal_exponents(x))
    sgs = range(extremal_subnormal_significands(x)..., length=n_subnormal_significands(x))
    mags = copy(NoValues)
    for xp in xps
        for sg in sgs
            push!(mags, xp * sg)
        end
    end
    mags
end

function subnormal_significand_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_magnitudes(x)
    iszero(n) && return copy(NoValues)
    xps = range(extremal_subnormal_exponent_values(x)..., length=n_subnormal_exponents(x))
    sgs = range(extremal_subnormal_significands(x)..., length=n_subnormal_significands(x))
    mags = copy(NoValues)
    for xp in xps
        for sg in sgs
            push!(mags, sg)
        end
    end
    mags
end

function normal_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_magnitudes(x)
    iszero(n) && return copy(NoValues)
    mags = admissable_normal_magnitudes(x)
    nan(x) && pop!(mags)
    inf(x) && pop!(mags)
    mags
end

function admissable_normal_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_admissable_normal_magnitudes(x)
    iszero(n) && return copy(NoValues)
    xps = range(extremal_normal_exponent_values(x)..., length=n_normal_exponents(x))
    sgs = range(extremal_normal_significands(x)..., length=n_normal_significands(x))
    mags = copy(NoValues)
    for xp in xps
        for sg in sgs
            push!(mags, xp * sg)
        end
    end
    mags
end

function normal_significand_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_significand_magnitudes(x)
    iszero(n) && return copy(NoValues)
    mags = admissable_normal_magnitudes(x)
    nan(x) && pop!(mags)
    inf(x) && pop!(mags)
    mags
end

function admissable_normal_significand_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_admissable_normal_magnitudes(x)
    iszero(n) && return copy(NoValues)
    xps = range(extremal_normal_exponent_values(x)..., length=n_normal_exponents(x))
    sgs = range(extremal_normal_significands(x)..., length=n_normal_significands(x))
    mags = copy(NoValues)
    for xp in xps
        for sg in sgs
            push!(mags,sg)
        end
    end
    mags
end

function subnormal_exponent_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_exponents(x)
    iszero(n) && return copy(NoValues)
    isone(n)  && return ValType[min_subnormal_exponent(x)]

    mn, mx = extremal_subnormal_exponents(x)
    mn2mx = range(start=mn, stop=mx, length=n)
    ValType[collect(mn2mx)...]
end

function normal_exponent_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_exponents(x)
    iszero(n) && return copy(NoValues)
    isone(n) && return ValType[min_normal_exponent(x)]

    mn, mx = extremal_normal_exponents(x)
    mn2mx = range(start=mn, stop=mx, length=n)
    ValType[collect(mn2mx)...]
end

function subnormal_significand_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_subnormal_significands(x)
    iszero(n) && return copy(NoValues)
    isone(n) && return ValType[min_subnormal_significand(x)]

    mn, mx = extremal_subnormal_significands(x)
    mn2mx = range(start=mn, stop=mx, length=n)
    ValType[collect(mn2mx)...]
end

function normal_significand_magnitudes(x::BinaryFloat{W,P}) where {W,P}
    n = n_normal_significands(x)
    iszero(n) && return copy(NoValues)
    isone(n) && return ValType[min_normal_significand(x)]

    mn, mx = extremal_normal_significands(x)
    mn2mx = range(start=mn, stop=mx, length=n)
    ValType[collect(mn2mx)...]
end



function ordinary_values(T::Type{<:BinaryFloat{W,P}}) where {W,P}
    vals = subnormal_values(T)
    append!(vals, normal_values(T))
    vals
end

function subnormal_values(T::Type{<:BinaryFloat{W,P}}) where {W,P}
    n_subnormals = n_subnormal_values(T)
    iszero(n_subnormals) && return NoValues()
    n_subnormal_sigs = n_subnormal_values(T)
    subnormal_exps = fill(min_subnormal_exponent(T), n_subnormal_sigs)
    subnormal_sigs = collect(range(start=min_subnormal_significand(T), stop=max_subnormal_significand(T), length=n_subnormal_sigs))
    RationalNK.(subnormal_sigs .* subnormal_exps)
end

function normal_values(T::Type{<:BinaryFloat{W,P}}) where {W,P}
    n_normals = n_normal_values(T)
    iszero(n_normals) && return NoValues()
    n_normal_sigs = n_normal_significands(T)
    n_normal_exps = n_normal_exponents(T)
    normal_exps = collect(range(start=min_normal_exponent(T), stop=max_normal_exponent(T), length=n_normal_exps))
    normal_sigs = collect(range(start=min_normal_significand(T), stop=max_normal_significand(T), length=n_normal_sigs))
    rep_exps = cld(n_normals, n_normal_exps)
    rep_sigs = cld(n_normals, n_normal_sigs)
    sigs = collect(Iterators.flatten(fill(normal_sigs, rep_sigs)))[1:n_normals]
    exps = collect(Iterators.flatten(transpose(hcat(fill(normal_exps, rep_exps)...))))[1:n_normals]
    sigs .* exps
end

function min_subnormal_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_subnormal_exponents(T)
    iszero(n) && return nothing
    return convert(RationalNK, Two^(0 - Base.exponent_bias(T)))
end

max_subnormal_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    min_subnormal_exponent(T)

max_biased_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = 2^n_exponent_bits(T) - 1
min_biased_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = 0

max_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = max_biased_exponent(T) - Base.exponent_bias(T)

function min_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
   n = n_normal_exponents(T)
   iszero(n) && return nothing
   0 - max_normal_exponent(T)
end

function min_normal_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_normal_exponents(T)
    iszero(n) && return nothing
    convert(RationalNK, Two^(0-Base.exponent_bias(T)))
end

function max_normal_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_normal_exponents(T)
    iszero(n) && return nothing
    isone(n) && return min_normal_exponent(T)
    convert(RationalNK, Two^(Base.exponent_bias(T)))
end

function min_subnormal_significand(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_subnormal_significands(T)
    iszero(n) && return nothing
    1//max(2,n)
end

function max_subnormal_significand(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_subnormal_significands(T)
    iszero(n) && return nothing
    isone(n) && return min_subnormal_significand(T)
    max(1,n-1)//max(2,n)
end

function min_normal_significand(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_normal_significands(T)
    iszero(n) && return nothing
    1//1 + 0//n
end

function max_normal_significand(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_normal_significands(T)
    iszero(n) && return nothing
    isone(n) && return min_normal_significand(T)
    1 + (n-1)//n
end


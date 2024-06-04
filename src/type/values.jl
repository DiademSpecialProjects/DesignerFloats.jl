function subnormal_values(T::Type{<:BinaryFloat{W,P}}) where {W,P}
    n_subnormals = n_subnormal_values(T)
    iszero(n_subnormals) && return NoValues()
    n_subnormal_sigs = n_subnormal_trailing_significands(T)
    subnormal_exponents = fill(min_subnormal_exponent(T), n_subnormal_sigs)
    subnormal_significands = collect(range(start=min_subnormal_significand(T), stop=max_subnormal_significand(T), length=n_subnormal_sigs))
    subnormal_signficands .* subnormal_exponents
end

function normal_values(T::Type{<:BinaryFloat{W,P}}) where {W,P}
    n_normals = n_normal_values(T)
    iszero(n_normals) && return NoValues()
    n_normal_sigs = n_normal_trailing_significands(T)
    n_normal_exps = n_normal_exponents(T)
    normal_exponents = collect(range(start=min_normal_exponent(T), stop=max_normal_exponent(T), length=n_normal_exps))
    normal_significands = collect(range(start=min_normal_significand(T), stop=max_normal_significand(T), length=n_normal_sigs))
    vcat((subnormal_signficands .* subnormal_exponents')...)
end

function min_subnormal_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_subnormal_exponents(T)
    iszero(n) && return nothing
    convert(RationalNK, 2.0^min_exponent(T))
end

max_subnormal_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    min_subnormal_exponent(T)

max_biased_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = 2^n_exponent_bits(T) - 1
min_biased_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = 0

max_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = max_biased_exponent(T) - Base.exponent_bias(T)
min_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = 0 - max_normal_exponent(T)

function min_normal_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_normal_exponents(T)
    iszero(n) && return nothing
    convert(RationalNK, 2.0^min_exponent(T))
end

function max_normal_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_normal_exponents(T)
    iszero(n) && return nothing
    convert(RationalNK, 2.0^max_exponent(T))
end

function min_subnormal_significand(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_subnormal_trailing_significands(T)
    iszero(n) && return nothing
    1 // (n + 1)
end

function max_subnormal_significand(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_subnormal_trailing_significands(T)
    iszero(n) && return nothing
    n // (n + 1)
end

function min_normal_significand(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_normal_trailing_significands(T)
    iszero(n) && return nothing
    1 // (n + 1)
end

function max_normal_significand(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_normal_trailing_significands(T)
    iszero(n) && return nothing
    n // (n + 1)
end


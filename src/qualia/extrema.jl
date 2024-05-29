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

# exponents

min_biased_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = 0
max_biased_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = 2^n_exponent_bits(T) - 1

min_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = min_biased_exponent(T)-exponent_bias(T)
max_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = max_biased_exponent(T)-exponent_bias(T)-1

function min_subnormal_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_subnormal_exponents(T)
    iszero(n) && return nothing
    RationalNK(2,1)^min_exponent(T)
end

max_subnormal_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    min_subnormal_exponent(T)

function minmax_subnormal_exponents(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_subnormal_exponents(T)
    iszero(n) && return copy(NoValues)
    simple_values(min_subnormal_exponent(T), max_subnormal_exponent(T))
end

function subnormal_exponent_range(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_subnormal_exponents(T)
    iszero(n) && return 1:0
    range(start=min_subnormal_exponent(T), stop=max_subnormal_exponent(T), length=n)
end

min_subnormal_exponent(x::T) where {T} = min_subnormal_exponent(T)
max_subnormal_exponent(x::T) where {T} = max_subnormal_exponent(T)
minmax_subnormal_exponents(x::T) where {T} = minmax_subnormal_exponent(T)
subnormal_exponent_range(x::T) where {T} = subnormal_exponent_range(T)

function min_normal_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_normal_exponents(T)
    iszero(n) && return nothing
    RationalNK(2,1)^min_exponent(T)
end

function max_normal_exponent(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_normal_exponents(T)
    iszero(n) && return nothing
    RationalNK(2,1)^max_exponent(T)
end

function minmax_normal_exponents(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_normal_exponents(T)
    iszero(n) && return copy(NoValues)
    simple_values(min_normal_exponent(T), max_normal_exponent(T))
end

function normal_exponent_range(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_normal_exponents(T)
    iszero(n) && return 1:0
    RationalNK.((2.0).^range(start=min_exponent(T), stop=max_exponent(T), length=n))
end

min_normal_exponent(x::T) where {T} = min_normal_exponent(T)
max_normal_exponent(x::T) where {T} = max_normal_exponent(T)
minmax_normal_exponents(x::T) where {T} = minmax_normal_exponent(T)
normal_exponent_range(x::T) where {T} = normal_exponent_range(T)

# significands

function min_subnormal_significand(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_subnormal_significands(T)
    iszero(n) && return nothing
    1//(n+1)
end

function max_subnormal_significand(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_subnormal_significands(T)
    iszero(n) && return nothing
    n//(n+1)
end

function minmax_subnormal_significands(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_subnormal_significands(T)
    iszero(n) && return copy(NoValues)
    simple_values(min_subnormal_significand(T), max_subnormal_significand(T))
end

function subnormal_significand_range(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_subnormal_significands(T)
    iszero(n) && return 1:0
    RationalNK.((2.0).^range(start=min_subnormal_significand(T), stop=max_subnormal_significand(T), length=n))
end

min_subnormal_significand(x::T) where {T} = min_subnormal_significand(T)
max_subnormal_significand(x::T) where {T} = max_subnormal_significand(T)
minmax_subnormal_significands(x::T) where {T} = minmax_subnormal_significands(T)
subnormal_significand_range(x::T) where {T} = subnormal_significand_range(T)

function min_normal_significand(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_normal_significands(T)
    iszero(n) && return nothing
    1//1
end

function max_normal_significand(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_normal_significands(T)
    iszero(n) && return nothing
    1 + (n-1)//n
end

function minmax_normal_significands(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_normal_significands(T)
    iszero(n) && return copy(NoValues)
    simple_values(min_normal_significand(T), max_normal_significand(T))
end

function normal_significand_range(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_normal_significands(T)
    iszero(n) && return 1:0
    RationalNK.((2.0).^range(start=min_normal_significand(T), stop=max_normal_significand(T), length=n))
end

min_normal_significand(x::T) where {T} = min_normal_significand(T)
max_normal_significand(x::T) where {T} = max_normal_significand(T)
minmax_normal_significands(x::T) where {T} = minmax_normal_significands(T)
normal_significand_range(x::T) where {T} = normal_significand_range(T)

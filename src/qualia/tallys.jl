#=
   n_values(x) == n_ordinary_values(x) + n_special_values(x)
=#

n_values(x::BinaryFloat{W,P}) where {W,P} = CountValues(x)
n_finite_values(x::BinaryFloat{W,P}) where {W,P} = CountFiniteValues(x)
n_ordinary_values(x::BinaryFloat{W,P}) where {W,P} = CountOrdinaryValues(x)
n_special_values(x::BinaryFloat{W,P}) where {W,P} = CountSpecialValues(x)
n_significands(x::BinaryFloat{W,P}) where {W,P} = CountSignificands(x)
n_exponents(x::BinaryFloat{W,P}) where {W,P} = CountExponents(x)
n_signs(x::BinaryFloat{W,P}) where {W,P} = CountSigns(x)

# magnitude counts

n_magnitudes(x::BinaryFloat{W,P}) where {W,P} =
    n_ordinary_magnitudes(x) + n_special_magnitudes(x)

n_ordinary_magnitudes(x::BinaryFloat{W,P}) where {W,P} =
    CountOrdinaryMagnitudes(x)

n_subnormal_magnitudes(x::BinaryFloat{W,P}) where {W,P} =
    n_subnormal_exponents(x) * n_subnormal_significands(x)

n_normal_magnitudes(x::BinaryFloat{W,P}) where {W,P} =
    n_normal_exponents(x) * n_normal_significands(x)

n_special_magnitudes(x::BinaryFloat{W,P}) where {W,P} =
    1 + inf(x)  # 1 for Zero

"""
     n_subnormal_exponents(::BinaryFloat{W,P})

- there is at most 1 subnormal exponent
  - it is the exponent of least magnitude
- if P==1, all ordinary values are normal
    - there are no subnormal values, no subnormal exponents
"""
n_subnormal_exponents(::Type{<:BinaryFloat{W,P}}) where {W,P} =
    isone(P) ? 0 : 1

"""
     n_normal_exponents(::BinaryFloat{W,P})

- if P==W, all ordinary values are subnormal
    - there are no normal values, no normal exponents
"""
function n_normal_exponents(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    P==W && return 0
    CountExponents(T)
end

n_ordinary_exponents(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
   n_normal_exponents(T)

"""
     n_subnormal_signficands(::BinaryFloat{W,P})

- if P==1, all ordinary values are normal
    - there are no subnormal values, no subnormal significands
- if P==W, all ordinary values are subnormal
otherwise
- there is one less subnormal significand than normal significands
    - subnormal significands never include 1, normal significands do
"""
function n_subnormal_signficands(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    P == 1 && return 0
    P == 2 && return 1
    P == W && n_normal_signficands(T) - 2
    n_normal_signficands(T) - 1
end

"""
     n_normal_signficands(::BinaryFloat{W,P})

- if P==1, all ordinary values are normal
    - there are no subnormal values, no subnormal significands
- if P==W, all ordinary values are subnormal
    - there are no normal values, no normal significances
"""
function n_normal_signficands(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    P == W && return 0
    P == 1 && return 1
    CountSignficands(T)
end

n_ordinary_signficands(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    n_normal_signficands(T)

const n_subnormal_significands = n_subnormal_signficands
const n_normal_significands = n_normal_signficands
const n_ordinary_significands = n_ordinary_signficands

# concrete counts

n_subnormal_exponents(x::BinaryFloat{W,P}) where {W,P} =
    n_subnormal_exponents(typeof(x))

n_normal_exponents(x::BinaryFloat{W,P}) where {W,P} =
    n_normal_exponents(typeof(x))

n_subnormal_signficands(x::BinaryFloat{W,P}) where {W,P} =
    n_subnormal_signficands(typeof(x))

n_normal_signficands(x::BinaryFloat{W,P}) where {W,P} =
    n_normal_signficands(typeof(x))



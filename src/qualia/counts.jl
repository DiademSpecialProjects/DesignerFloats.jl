# counts

n_special_values(::Type{T}) where {T<:UnsignedFloat} = 3 # 0, NaN, Inf
n_special_values(::Type{T}) where {T<:FiniteUnsignedFloat} = 2 # 0, NaN
n_special_values(::Type{T}) where {T<:SignedFloat} = 4 # 0, NaN, +/- Inf
n_special_values(::Type{T}) where {T<:FiniteSignedFloat} = 2 # 0, NaN

n_ordinary_values(::Type{T}) where {T<:BinaryFloat} = n_values(T) - n_special_values(T)
n_finite_values(::Type{T}) where {T<:BinaryFloat} = n_ordinary_values(T) + 1 # 0
n_subnormal_values(::Type{T}) where {T<:BinaryFloat} = 2 * n_subnormals(T)
n_normal_values(::Type{T}) where {T<:BinaryFloat} = n_ordinary_values(T) - n_subnormal_values(T)

n_ordinary_values(x::T) where {T<:BinaryFloat} = n_ordinary_values(T)
n_finite_values(x::T) where {T<:BinaryFloat} = n_finite_values(T)
n_subnormal_values(x::T) where {T<:BinaryFloat} = n_subnormal_values(T)
n_normal_values(x::T) where {T<:BinaryFloat} = n_normal_values(T)


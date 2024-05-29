is_signed(::Type{T}) where {T<:UnsignedBinaryFloat} = false
is_signed(::Type{T}) where {T<:SignedBinaryFloat} = true

is_unsigned(::Type{T}) where {T<:BinaryFloat} = !is_signed(T)

is_finite(::Type{T}) where {T<:FiniteSignedFloat} = true
is_finite(::Type{T}) where {T<:FiniteUnsignedFloat} = true
is_finite(::Type{T}) where {T<:SignedFloat} = false
is_finite(::Type{T}) where {T<:UnsignedFloat} = false

is_extended(::Type{T}) where {T<:FiniteSignedFloat} = false
is_extended(::Type{T}) where {T<:FiniteUnsignedFloat} = false
is_extended(::Type{T}) where {T<:SignedFloat} = true
is_extended(::Type{T}) where {T<:UnsignedFloat} = true

has_infinity(::Type{T}) where {T} = is_extended(T)

is_signed(x::T) where {T} = is_signed(T)
is_unsigned(x::T) where {T} = is_unsigned(T)

is_finite(x::T) where {T} = is_finite(T)
is_extended(x::T) where {T} = is_extended(T)
has_infinity(x::T) where {T} = has_infinity(T)

is_signed(x::T) where {T<:BinaryFloat} = is_signed(T)
is_unsigned(x::T) where {T<:BinaryFloat} = !is_signed(T)
      
is_finite(X::T) where {T<:BinaryFloat} = is_finite(T)
is_extended(X::T) where {T<:BinaryFloat} = is_extended(T)

has_infinity(::Type{T}) where {T<:BinaryFloat} = !is_finite(T)
has_infinity(x::T) where {T<:BinaryFloat} = !is_finite(T)

Base.isinteger(x::BinaryFloat) = isinteger(value(x))
Base.isfinite(x::BinaryFloat) = isfinite(value(x))
Base.isinf(x::BinaryFloat) = isinf(value(x))
Base.isnan(x::BinaryFloat) = isnan(value(x))
Base.signbit(x::BinaryFloat) = signbit(value(x))

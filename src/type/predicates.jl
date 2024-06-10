is_signed(::Type{T}) where {T<:SimpleBinaryFloat} = false
is_signed(::Type{T}) where {T<:UnsignedBinaryFloat} = false
is_signed(::Type{T}) where {T<:SignedBinaryFloat} = true

is_unsigned(::Type{T}) where {T<:BinaryFloat} = !is_signed(T)

is_finite(::Type{T}) where {T<:SimpleBinaryFloat} = true
is_finite(::Type{T}) where {T<:FiniteSignedFloat} = true
is_finite(::Type{T}) where {T<:FiniteUnsignedFloat} = true
is_finite(::Type{T}) where {T<:SignedFloat} = false
is_finite(::Type{T}) where {T<:UnsignedFloat} = false

is_extended(::Type{T}) where {T<:SimpleBinaryFloat} = false
is_extended(::Type{T}) where {T<:FiniteSignedFloat} = false
is_extended(::Type{T}) where {T<:FiniteUnsignedFloat} = false
is_extended(::Type{T}) where {T<:SignedFloat} = true
is_extended(::Type{T}) where {T<:UnsignedFloat} = true

has_infinity(::Type{T}) where {T<:BinaryFloat} = is_extended(T)

has_nan(::Type{T}) where {T<:SimpleBinaryFloat} = false
has_nan(::Type{T}) where {T<:FiniteSignedFloat} = true
has_nan(::Type{T}) where {T<:FiniteUnsignedFloat} = true
has_nan(::Type{T}) where {T<:SignedFloat} = true
has_nan(::Type{T}) where {T<:UnsignedFloat} = true

for F in (:is_signed, :is_unsigned, :is_finite, :is_extended, :has_infinity, :has_nan)
    @eval $F(x::T) where {T<:BinaryFloat} = $F(T)
end

Base.isinteger(x::BinaryFloat) = isinteger(value(x))
Base.isfinite(x::BinaryFloat) = isfinite(value(x))
Base.isinf(x::BinaryFloat) = isinf(value(x))
Base.isnan(x::BinaryFloat) = isnan(value(x))
Base.signbit(x::BinaryFloat) = signbit(value(x))

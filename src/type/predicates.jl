is_signed(::Type{T}) where {T<:UnsignedBinaryFloat} = false
is_signed(::Type{T}) where {T<:SignedBinaryFloat} = true
is_signed(x::T) where {T<:BinaryFloat} = is_signed(T)

is_unsigned(::Type{T}) where {T<:BinaryFloat} = !is_signed(T)
is_unsigned(x::T) where {T<:BinaryFloat} = !is_signed(T)
      
is_finite(::Type{T}) where {T<:FiniteSignedFloat} = true
is_finite(::Type{T}) where {T<:FiniteUnsigedFloat} = true
is_finite(::Type{T}) where {T<:SignedFloat} = false
is_finite(::Type{T}) where {T<:UnsigedFloat} = false
is_finite(X::T) where {T<:BinaryFloat} = is_finite(T)

has_infinity(::Type{T}) where {T<:BinaryFloat} = !is_finite(T)
has_infinity(x::T) where {T<:BinaryFloat} = !is_finite(T)


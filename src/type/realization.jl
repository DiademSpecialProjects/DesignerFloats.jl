# realizations

#=
   concrete subtypes of BinaryFloat

- subtypes of UnsignedBinaryFloat encode non-negative values
- subtypes of SignedBinaryFloat encode non-negative and negative values
=#

const FPValue = Float32
const Encoding = UInt16

struct SignedFloat{Width, Precision} <: SignedBinaryFloat{Width, Precision}
   value::FPValue
   code::Encoding
end

struct FiniteSignedFloat{Width, Precision} <: SignedBinaryFloat{Width, Precision}
   value::FPValue
   code::Encoding
end

struct UnsignedFloat{Width, Precision} <: UnsignedBinaryFloat{Width, Precision}
   value::FPValue
   code::Encoding
end

struct FiniteUnsignedFloat{Width, Precision} <: UnsignedBinaryFloat{Width, Precision}
   value::FPValue
   code::Encoding
end

value(x::BinaryFloat} = x.value
code(x::BinaryFloat} = x.code

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



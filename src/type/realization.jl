# realizations

#=
   concrete subtypes of BinaryFloat

- subtypes of UnsignedBinaryFloat encode non-negative values
- subtypes of SignedBinaryFloat encode non-negative and negative values
=#

const FPValue = Float64
const Encoding = UInt16

mutable struct SignedFloat{Width, Precision} <: SignedBinaryFloat{Width, Precision}
   value::FPValue
   code::Encoding
end
SignedFloat(Width, Precision) = 
    if 1 <= Precision < Width
        SignedFloat{Width, Precision}(zero(FPValue), zero(Encoding))
    else
        throw(DomainError("!(1 <= Precision ($Precision) < Width ($Width))"))
    end
   
mutable struct FiniteSignedFloat{Width, Precision} <: SignedBinaryFloat{Width, Precision}
   value::FPValue
   code::Encoding
end
FiniteSignedFloat(Width, Precision) =
    if 1 <= Precision < Width
        FiniteSignedFloat{Width, Precision}(zero(FPValue), zero(Encoding))
    else
        throw(DomainError("!(1 <= Precision ($Precision) < Width ($Width))"))
    end

mutable struct UnsignedFloat{Width, Precision} <: UnsignedBinaryFloat{Width, Precision}
   value::FPValue
   code::Encoding
end
UnsignedFloat(Width, Precision) =
    if 1 <= Precision < Width
        UnsignedFloat{Width, Precision}(zero(FPValue), zero(Encoding))
    else
        throw(DomainError("!(1 <= Precision ($Precision) < Width ($Width))"))
    end

mutable struct FiniteUnsignedFloat{Width, Precision} <: UnsignedBinaryFloat{Width, Precision}
   value::FPValue
   code::Encoding
end
FiniteUnsignedFloat(Width, Precision) =
    if 1 <= Precision < Width
        FiniteUnsignedFloat{Width, Precision}(zero(FPValue), zero(Encoding))
    else
        throw(DomainError("!(1 <= Precision ($Precision) < Width ($Width))"))
    end

value(x::BinaryFloat) = x.value
value(::Type{T}, x::BinaryFloat) where {T<:AbstractFloat} = T(value(x))

code(x::BinaryFloat} = x.code
code(::Type{T}, x::BinaryFloat} where {T:<Integer} = T(x.code)

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



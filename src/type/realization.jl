# realizations

#=
   concrete subtypes of BinaryFloat

- subtypes of UnsignedBinaryFloat encode positive and special values
- subtypes of SignedBinaryFloat encode positive, negative and special values
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

value(x::T) where {T<:BinaryFloat} = getfield(x, :value)
value(::Type{T}, x::BinaryFloat) where {T<:AbstractFloat} = T(value(x))

code(x::T) where {T<:BinaryFloat} = getfield(x, :code)
code(::Type{T}, x::BinaryFloat) where {T<:Integer} = T(code(x))

valuecode(x::T) where {T<:BinaryFloat} = (value(x), code(x))

value!(x::T, v::FPValue) where {T<:BinaryFloat} = setfield!(x, :value, v)
code!(x::T, v::Encoding) where {T<:BinaryFloat} = setfield!(x, :code, v)

value!(x::T, v::AbstractFloat) where {T<:BinaryFloat} = setfield!(x, :value, FPValue(v))
code!(x::T, v::Integer) where {T<:BinaryFloat} = setfield!(x, :code, Encoding(v))

is_signed(x::T) where {T} = is_signed(T)
is_unsigned(x::T) where {T} = is_unsigned(T)

is_finite(::Type{T}) where {T<:FiniteSignedFloat} = true
is_finite(::Type{T}) where {T<:FiniteUnsignedFloat} = true
is_finite(::Type{T}) where {T<:SignedFloat} = false
is_finite(::Type{T}) where {T<:UnsignedFloat} = false

is_extended(::Type{T}) where {T<:FiniteSignedFloat} = false
is_extended(::Type{T}) where {T<:FiniteUnsignedFloat} = false
is_extended(::Type{T}) where {T<:SignedFloat} = true
is_extended(::Type{T}) where {T<:UnsignedFloat} = true

has_infinity(::Type{T}) where {T} = is_extended(T)

is_finite(x::T) where {T} = is_finite(T)
is_extended(x::T) where {T} = is_extended(T)
has_infinity(x::T) where {T} = has_infinity(T)



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

valuecode!(x::T, v::FPValue, ̧c::Encoding) where {T<:BinaryFloat} = (value!(x, v); code!(x, c))

value!(x::T, v::AbstractFloat) where {T<:BinaryFloat} = setfield!(x, :value, FPValue(v))
code!(x::T, v::Integer) where {T<:BinaryFloat} = setfield!(x, :code, Encoding(v))

valuecode!(x::T, v::AbstractFloat, ̧c::Integer) where {T<:BinaryFloat} = (value!(x, FPValue(v)); code!(x, Encoding(c)))

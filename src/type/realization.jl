# realizations

#=
   concrete subtypes of BinaryFLOAT

- UnsigneFloat (encodes non-negative values)
- SignedFloat (encodes non-negative and negative values)
=#

"""
    UnsignedFloat{Width, Precision}

All `UnsignedFloats` encode a single Zero value.
- Zero is neither positive nor negative.
- There is no -0. When converting, -0 is mapped to Zero.

- supertype is BinaryFloat{W,P} <: AbstractFloat
"""
Base.@kwdef struct UnsignedFloat{W,P} <: UnsignedBinaryFloat{W,P}
    inf::Bool = false

    function UnsignedFloat{W,P}(inf::Bool, nan::Bool) where {W,P}
        @assert (W >= P) && (P > 0)
        new{W,P}(inf, nan)
    end
end

UnsignedFloat(Width, Precision; inf::Bool=false, nan::Bool=true) =
    UnsignedFloat{Width,Precision}(inf, nan)

"""
    SignedFloat{Width, Precision}

All `SignedFloats` encode a single Zero value.
- Zero is neither positive nor negative.
- There is no -0, When converting, -0 is mapped to Zero.

- supertype is BinaryFloat{W,P} <: AbstractFloat
"""
Base.@kwdef struct SignedFloat{W,P} <: SignedBinaryFloat{W,P}
    inf::Bool = false
    nan::Bool = true

    function SignedFloat{W,P}(inf::Bool, nan::Bool) where {W,P}
        @assert (W >= P) && (P > 0)
        inf && @assert (W > 2)  # W==2 -> {-Inf, 0, NaN, +Inf}
        new{W,P}(inf, nan)
    end
end

SignedFloat(Width, Precision; inf::Bool=false, nan::Bool=true) =
    SignedFloat{Width,Precision}(inf, nan)

# field value retreivals

"""
     inf(<:BinaryFloat)

true iff the format encodes Inf
- UnsignedFloats may have +Inf, or not
- SignedFloats may have both +Inf and -Inf, or neither
"""
hasinf(x::T) where {W,P,T<:BinaryFloat{W,P}} = getfield(x, :inf)

"""
     nan(<:BinaryFloat)

true iff the format encodes NaN
- All BinaryFloats encode one NaN
"""
hasnan(x::T) where {W,P,T<:BinaryFLOAT{W,P}} = true

# characteristics

"""
    ExpBits(::BinaryFLOAT{W,P})

ExpBits is the number of bits in the exponent field.
"""
ExpBits(::Type{<:SignedFLOAT{W,P}}) where {W,P} = W - P
ExpBits(::Type{<:UnsignedFLOAT{W,P}}) where {W,P} = W - P + 1

Width(x::BinaryFLOAT{W,P}) where {W,P} = Width(typeof(x))
Precision(x::BinaryFLOAT{W,P}) where {W,P} = Precision(typeof(x))
ExpBits(x::BinaryFLOAT{W,P}) where {W,P} = ExpBits(typeof(x))
ExpBias(x::BinaryFLOAT{W,P}) where {W,P} = ExpBias(typeof(x))
TrailingSignificandBits(x::BinaryFLOAT{W,P}) where {W,P} = TrailingSignificandBits(typeof(x))

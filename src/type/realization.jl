# realizations

#=
   concrete subtypes of BinaryFLOAT

- UnsigneFloat (encodes non-negative values)
- SignedFLOAT  (encodes non-negative and negative values)
=#

"""
    UnsignedFLOAT{Width, Precision}

All `UnsignedFLOATs` encode a single Zero value.
- Zero is neither positive nor negative.
- There is no -0. When converting, -0 is mapped to Zero.

- supertype is BinaryFLOAT{W,P} <: AbstractFloat
"""
Base.@kwdef struct UnsignedFLOAT{W,P} <: BinaryFLOAT{W,P}
    inf::Bool = false
    nan::Bool = true

    function UnsignedFLOAT{W,P}(inf::Bool, nan::Bool) where {W,P}
        @assert (W >= P) && (P > 0)
        new{W,P}(inf, nan)
    end
end

UnsignedFLOAT(Width, Precision; inf::Bool=false, nan::Bool=true) =
    UnsignedFLOAT{Width,Precision}(inf, nan)

"""
    SignedFLOAT{Width, Precision}

All `SignedFLOATs` encode a single Zero value.
- Zero is neither positive nor negative.
- There is no -0, When converting, -0 is mapped to Zero.

- supertype is BinaryFLOAT{W,P} <: AbstractFloat
"""
Base.@kwdef struct SignedFLOAT{W,P} <: BinaryFLOAT{W,P}
    inf::Bool = false
    nan::Bool = true

    function SignedFLOAT{W,P}(inf::Bool, nan::Bool) where {W,P}
        @assert (W >= P) && (P > 0)
        inf && @assert (W > 2)  # W==2 -> {-Inf, 0, NaN, +Inf}
        new{W,P}(inf, nan)
    end
end

SignedFLOAT(Width, Precision; inf::Bool=false, nan::Bool=true) =
    SignedFLOAT{Width,Precision}(inf, nan)

# field value retreivals

"""
     inf(<:BinaryFLOAT)

true iff the format encodes Inf
- UnsignedFLOATs may have +Inf, or not
- SignedFLOATs may have both +Inf and -Inf, or neither
"""
inf(x::T) where {W,P,T<:BinaryFLOAT{W,P}} = getfield(x, :inf)

"""
     nan(<:BinaryFLOAT)

true iff the format encodes NaN
- UnsignedFLOATs may enode one NaN, or not
- SignedFLOATs **always** encode one NaN
"""
nan(x::T) where {W,P,T<:BinaryFLOAT{W,P}} = getfield(x, :nan)

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

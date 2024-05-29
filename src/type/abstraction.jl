"""
     BinaryFloat{Width, Precision}

This is an abstract type, the subtype of AbstractFloat.

- All BinaryFloat formats encode one Zero value
    - Zero is neither positive nor negative 
    - there is no -0 value
    - when converting from a format with -0, -0 maps to 0

It is the immediate (and shared) supertype of 
SignedFloat and UnsignedFloat.

- Width is the storage width in bits.
- Precision is significand (with implicit bit) bitwidth. 
"""
abstract type BinaryFloat{W,P} <: AbstractFloat end

"""
     SignedBinaryFloat{Width, Precision}

This is an abstract type, the subtype of BinaryFloat.

It is the immediate (and shared) supertype of 
ExtendedSignedFloat and FiniteSignedFloat.

- Width is the storage width in bits.
- Precision is significand (with implicit bit) bitwidth. 
"""
abstract type SignedBinaryFloat{W,P} <: BinaryFloat{W,P} end

"""
     UnsignedBinaryFloat{Width, Precision}

This is an abstract type, the subtype of BinaryFloat.

It is the immediate (and shared) supertype of
ExtendedUnsignedFloat and FiniteUnsignedFloat.

- Width is the storage width in bits.
- Precision is significand (with implicit bit) bitwidth. 
"""
abstract type UnsignedBinaryFloat{W,P} <: BinaryFloat{W,P} end

is_signed(::Type{T}) where {T<:SignedBinaryFloat} = true
is_signed(::Type{T}) where {T<:UnsignedBinaryFloat} = false

is_unsigned(::Type{T}) where {T<:SignedBinaryFloat} = false
is_unsigned(::Type{T}) where {T<:UnsignedBinaryFloat} = true

#=
"""
     ExtendedSignedBinaryFloat{Width, Precision}

This is an abstract type, a subtype of SignedBinaryFloat.

It is the immediate supertype of the struct `ExtendedSignedFloat`.

- Width is the storage width in bits.
- Precision is significand (with implicit bit) bitwidth. 

see [`ExtendedSignedFloat`](@ref)
"""
abstract type ExtendedSignedBinaryFloat{W,P} <: SignedBinaryFloat{W,P}     

"""
     FiniteSignedBinaryFloat{Width, Precision}

This is an abstract type, a subtype of SignedBinaryFloat.

It is the immediate supertype of the struct `FiniteSignedFloat`.

- Width is the storage width in bits.
- Precision is significand (with implicit bit) bitwidth. 

see [`FiniteSignedFloat`](@ref)
"""
abstract type FiniteSignedBinaryFloat{W,P} <: SignedBinaryFloat{W,P}     

"""
     ExtendedUnsignedBinaryFloat{Width, Precision}

This is an abstract type, a subtype of SignedBinaryFloat.

It is the immediate supertype of the struct `ExtendedUnsignedFloat`.

- Width is the storage width in bits.
- Precision is significand (with implicit bit) bitwidth. 

see [`ExtendedUnsignedFloat`](@ref)
"""
abstract type ExtendedUnsignedBinaryFloat{W,P} <: UnsignedBinaryFloat{W,P}     

"""
     FiniteUnsignedBinaryFloat{Width, Precision}

This is an abstract type, a subtype of UnsignedBinaryFloat.

It is the immediate supertype of the struct `FiniteUnsignedFloat`.

- Width is the storage width in bits.
- Precision is significand (with implicit bit) bitwidth. 

see [`FiniteUnsignedFloat`](@ref)
"""
abstract type FiniteUnsignedBinaryFloat{W,P} <: UnsignedBinaryFloat{W,P}     
=#

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
- the middle+1 encoding is used for NaN
"""
abstract type SignedBinaryFloat{W,P} <: BinaryFloat{W,P} end

"""
     UnsignedBinaryFloat{Width, Precision}

This is an abstract type, the subtype of BinaryFloat.

It is the immediate (and shared) supertype of
ExtendedUnsignedFloat and FiniteUnsignedFloat.

- Width is the storage width in bits.
- Precision is significand (with implicit bit) bitwidth. 
- the final encoding is used for NaN
"""
abstract type UnsignedBinaryFloat{W,P} <: BinaryFloat{W,P} end

"""
     SimpleBinaryFloat{Width, Precision}

This is an abstract type, the subtype of BinaryFloat.

It is the immediate (and shared) supertype of
SimpleFloat.

- Width is the storage width in bits.
- Precision is significand (with implicit bit) bitwidth. 
- there is no NaN encoding
"""
abstract type SimpleBinaryFloat{W,P} <: UnsignedBinaryFloat{W,P} end

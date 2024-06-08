The local abstract top type is `BinaryFloat`.  It is a subtype of `AbstractFloat` with two parameters, _BitWidth_ (W) and _Precision_ (P): `BinaryFloat{W,P} <: AbstractFloat`. BitWidth gives the count of contiguous bits spanned by the abstract type.  For example a byte encoded float is a subtype of `BinaryFloat{8,P}`. Precision gives the count of significant bits, this includes the implicit (or hidden) bit.  The bits of precision form the unscaled absolute value, while the exponent scales that value.  For example, a byte encoded float with 5 bits of precision is a subtype of `BinaryFloat{8,5}`.

The precision must be at least 1 and cannot exceed the bitwidth.  In practice, the precision is less than the bitwidth:
`0 < precision < bitwidth`.  
A more useful constriant is 
`2 <= precision <= bitwidth - 2`.

Sub-abstractions of BinaryFloat are `UnsignedBinaryFloat` and `SignedBinaryFloat`. They share the parameters `{W,P}`. There is unique abstract subtype of `UnsignedBinaryFloat{W,P}`, `SimpleBinaryFloat{W,P}`. This is immediate supertype for the most simply constructed binary float with bitwidth W and precision P. All other concrete binary float types are developable from that.


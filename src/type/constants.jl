BitIntegers.@define_integers 2048
const Int1K = BitIntegers.Int1024
const Int2K = Int2048
const IntNK = Int2K

const RationalNK = Rational{IntNK}
const Rational64 = Rational{Int64}

const ValType  = Union{Int64, IntNK, Float64, Rational64, RationalNK}
const NoValues = ValType[]

const Zero   = RationalNK( 0, 1)
const PosOne = RationalNK( 1, 1)
const NegOne = RationalNK(-1, 1)
const PosInf = RationalNK( 1, 0)
const NegInf = RationalNK(-1, 0)

const One = Float128(1)
const Two = Float128(2)

Base.convert(Quadmath.Float128, x::BitIntegers.Int1024) =
    Float128(BigFloat(BigInt(x)))
Base.convert(Quadmath.Float128, x::BitIntegers.Int2048) =
    Float128(BigFloat(BigInt(x)))

Quadmath.Float128(x::BitIntegers.Int1024) =
    convert(Quadmath.Float128, x)
Quadmath.Float128(x::BitIntegers.Int2048) =
    convert(Quadmath.Float128, x)

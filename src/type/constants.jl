BitIntegers.@define_integers 2048
BitIntegers.@define_integers 3072
const Int1K = BitIntegers.Int1024
const Int2K = Int2048
const Int3K = Int3072
const Int4K = Int4096
const IntNK = Int4K

const RationalNK = Rational{IntNK}
const Rational64 = Rational{Int64}

const NoValues = Real[]

const Zero   = RationalNK( 0, 1)
const PosOne = RationalNK( 1, 1)
const NegOne = RationalNK(-1, 1)
const PosInf = RationalNK( 1, 0)
const NegInf = RationalNK(-1, 0)

const One = Float128(1)
const Two = Float128(2)

Base.convert(::Type{Quadmath.Float128}, x::Int1024) =
    Float128(BigFloat(BigInt(x)))
Base.convert(::Type{Quadmath.Float128}, x::Int2048) =
    Float128(BigFloat(BigInt(x)))

Quadmath.Float128(x::Int1024) =
    convert(Quadmath.Float128, x)
Quadmath.Float128(x::Int2048) =
    convert(Quadmath.Float128, x)

BitIntegers.@define_integers 2048
const Int1K = BitIntegers.Int1024
const Int2K = Int2048
const HugeInt = Int2K

const RationalNK = Rational{HugeInt}
const Rational64 = Rational{Int64}

const ValType  = Union{RationalNK, Rational64, Float64}
const NoValues = ValType[]

const Zero   = RationalNK( 0, 1)
const PosOne = RationalNK( 1, 1)
const NegOne = RationalNK(-1, 1)
const PosInf = RationalNK( 1, 0)
const NegInf = RationalNK(-1, 0)


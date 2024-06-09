BitIntegers.@define_integers 2048
BitIntegers.@define_integers 3072
BitIntegers.@define_integers 4096
BitIntegers.@define_integers 5120

const Int1K = BitIntegers.Int1024
const Int2K = Int2048
const Int3K = Int3072
const Int4K = Int4096
const Int5K = Int5120
const IntNK = Int4K

const RationalNK = Rational{IntNK}
const Rational64 = Rational{Int64}

const NoValue = Real[]
NoValues() = copy(NoValue)

const Zero   = RationalNK( 0, 1)
const PosOne = RationalNK( 1, 1)
const NegOne = RationalNK(-1, 1)
const PosInf = RationalNK( 1, 0)
const NegInf = RationalNK(-1, 0)

const One = Float128(1)
const Two = Float128(2)

for I in (:Int1024, :Int2048, :Int4096)
  @eval begin
    Base.convert(::Type{Quadmath.Float128}, x::$I) = Float128(BigFloat(BigInt(x)))
    Quadmath.Float128(x::$I) = convert(Quadmath.Float128, x)
  end
end

function Base.convert(::Type{RationalNK}, x::AbstractFloat)
    fr,xp = frexp(x)
    qfr = RationalNK(fr)
    twopxp = RationalNK(IntNK(Two^abs(xp)))
    qxp = signbit(xp) ? 1 // twopxp : twopxp
    qfr * qxp
end

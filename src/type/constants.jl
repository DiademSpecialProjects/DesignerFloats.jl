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

const Shift128ToInt = Float128(2)^(precision(Float128))
const IntOfShift128 = IntNK(BigInt(Shift128ToInt))

for I in (:Int1024, :Int2048, :Int4096)
  @eval begin
    Base.convert(::Type{Quadmath.Float128}, x::$I) = Float128(BigFloat(BigInt(x)))
    Quadmath.Float128(x::$I) = convert(Quadmath.Float128, x)
  end
end

signum(x::Real) = signbit(x) ? -1 : iszero(x) ? 0 : 1

function Base.convert(::Type{RationalNK}, x::Quadmath.Float128)
  fr, xp = frexp(x)                          # x == fr * oftype(x, 2)
  s, afr = signum(fr), abs(fr)               # afr in [1/2, 1) or 0
  if isinteger(afr)
    qfr = iszero(afr) ? Zero : One
  else
    ifr = convert(IntNK, convert(BigInt, afr * Shift128ToInt))
    qfr = RationalNK(ifr, IntOfShift128)
  end
  twopxp = RationalNK(IntNK(Two^abs(xp)))
  qxp = signbit(xp) ? 1 // twopxp : twopxp
  qfr * qxp
end

function Base.convert(::Type{Rational{I}}, x::Quadmath.Float128) where {I}
  Q = Rational{I}
  fr, xp = frexp(x)                          # x == fr * oftype(x, 2)
  s, afr = signum(fr), abs(fr)               # afr in [1/2, 1) or 0
  if isinteger(afr)
    qfr = iszero(afr) ? Zero : One
  else
    ifr = convert(IntNK, convert(BigInt, afr * Shift128ToInt))
    qfr = Q(ifr, IntOfShift128)
  end
  twopxp = RationalNK(IntNK(Two^abs(xp)))
  qxp = signbit(xp) ? 1 // twopxp : twopxp
  qfr * qxp
end

function Base.convert(::Type{Rational{I}}, x::T) where {I, T<:AbstractFloat}
  Q = Rational{I}
  ShiftFloatToInt = T(2)^(precision(T))
  IntOfShiftFloat = I(BigInt(ShiftFloatToInt))
  fr, xp = frexp(x)                          # x == fr * oftype(x, 2)
  s, afr = signum(fr), abs(fr)               # afr in [1/2, 1) or 0
  if isinteger(afr)
    qfr = iszero(afr) ? Zero : One
  else
    ifr = convert(I, convert(BigInt, afr * ShiftFloatToInt))
    qfr = Q(ifr, IntOfShiftFloat)
  end
  twopxp = Q(I((Q(2,1))^abs(xp)))
  qxp = signbit(xp) ? 1 // twopxp : twopxp
  qfr * qxp
end

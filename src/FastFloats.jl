module FastFloats

export BinaryFloat, SignedBinaryFloat, UnsignedBinaryFloat,
       SignedFloat, FiniteSignedFloat, UnsignedFloat, FiniteUnsignedFloat,
       width, precision, n_bits, n_values, n_numeric_values,
       n_significant_bits, n_trailing_bits, n_signficands, n_subnormal_significands,
       n_exponent_bits, n_exponent_values, exponent_bias,
       is_signed, is_unsigned, is_finite, has_infinity,
       value, code, valuecode, value!, code!

using BitOperations                     # bitfields: mask, shift, unmask
using BitIntegers, Quadmath             # Int1024, Float128
using Dictionaries                      # order stable associative arrays
using CSV, Tables, DataFrames           # tables in memory and in files
using Printf, PrettyTables              # hexadecimal strings

include("type/constants.jl")
include("type/abstraction.jl")
include("type/realization.jl")
include("type/predicates.jl")
include("type/counts.jl")

include("qualia/tallys.jl")
include("qualia/extrema.jl")
include("qualia/magnitudes.jl")

include("provide/showstring.jl")
include("provide/values.jl")
include("provide/encodings.jl")
include("provide/tables.jl")

end  # DesignerFloats


module FastFloats

export BinaryFloat, SignedBinaryFloat, UnsignedBinaryFloat,
       SignedFloat, FiniteSignedFloat, UnsignedFloat, FiniteUnsignedFloat,
       width, precision, n_bits, n_values, n_numeric_values,
       n_significant_bits, n_trailing_bits, n_exponent_bits,
       n_significands, n_subnormal_significands, n_normal_significands,
       n_exponents, n_subnormal_exponents, n_normal_exponents, exponent_bias,
       n_magnitudes, n_finite_magnitudes, n_ordinary_magnitudes,
       n_subnormal_magnitudes, n_normal_magnitudes,
       magnitudes, all_values,
       is_signed, is_unsigned, is_finite, is_extended, has_infinity,
       value, code, valuecode, value!, code!,
       round_to_precision

import Base: precision, exponent_bias

using BitOperations                     # bitfields: mask, shift, unmask
using BitIntegers, Quadmath             # Int1024, Float128
using Dictionaries                      # order stable associative arrays
using CSV, Tables, DataFrames           # tables in memory and in files
using Printf, PrettyTables              # hexadecimal strings
using LaTeXStrings, Latexify            # for prettytable latex backend

include("type/constants.jl")
include("type/abstraction.jl")
include("type/realization.jl")
include("type/predicates.jl")

include("qualia/counts.jl")
include("qualia/extrema.jl")
include("qualia/magnitudes.jl")

include("rounding/modes.jl")
include("rounding/toprecision.jl")

include("provide/showstring.jl")
include("provide/values.jl")
include("provide/encodings.jl")
include("provide/tables.jl")

end  # DesignerFloats


module FastFloats

export BinaryFLOAT, SignedFLOAT, UnsignedFLOAT,
       all_values

using BitOperations                     # bitfields: mask, shift, unmask
using BitIntegers, Quadmath             # Int1024, Float128
using Dictionaries                      # order stable associative arrays
using CSV, Tables, DataFrames           # tables in memory and in files
using Printf, PrettyTables              # hexadecimal strings

include("type/constants.jl")
include("type/abstraction.jl")
include("type/realization.jl")
include("type/predicates.jl")

include("qualia/counts.jl")
include("qualia/tallys.jl")
include("qualia/extrema.jl")
include("qualia/magnitudes.jl")

include("provide/showstring.jl")
include("provide/values.jl")
include("provide/encodings.jl")
include("provide/tables.jl")

end  # DesignerFloats


function offsets_and_values(x::T) where {W,P,T<:BinaryFloat{W,P}}
    values = all_values(x)
    offsets = all_offsets(x)
    offset2value = Dictionary(offsets, values)
    value2offset = Dictionary(values, offsets)
    (offset2value, value2offset)
end

all_significand_absvalues(x::T) where {W,P,T<:BinaryFloat{W,P}} =
   map(abs, all_significand_values(x))

function all_sign_values(x::T) where {W,P,T<:UnsignedBinaryFloat{W,P}}
    fill(0, n_values(x))
end

function all_sign_values(x::T) where {W,P,T<:SignedBinaryFloat{W,P}}
    vcat( fill(0, n_values(x)>>1), fill(1, n_values(x)>>1) )
end

"""
    all_offsets(x::BinaryFloat{W,P})

offsets are 0-based
"""
function all_offsets(x::T) where {W,P,T<:BinaryFloat{W,P}}
    n = CountValues(x)
    if n <= 256
        offsets = map(UInt8, collect(0:n-1))
    else
        offsets = map(UInt16, collect(0:n-1))
    end
    offsets
end


function all_encodings(x::UnsignedFloat{W,P}) where {W,P}
    values = all_values(x)
    offsets = all_offsets(x)
    offset2value = Dictionary(offsets, values)
    value2offset = Dictionary(values, offsets)
    # indices = all_indices(x)
    # index2value = Dictionary(indices, values)
    # value2index = Dictionary(values, indices)
    (offset2value, value2offset)
end

function all_values(x::UnsignedFloat{W,P}) where {W,P}
    seq = vcat(Zero, ordinary_magnitudes(x))
    if inf(x)
        if nan(x)
            seq[end-1] = Inf
            seq[end] = NaN
        else
            seq[end] = Inf
        end
    elseif nan(x)
        seq[end] = NaN
    end
    Real[seq...]
end

function all_values(x::SignedFloat{W,P}) where {W,P}
    n = CountValues(x)
    seq = vcat(Zero, ordinary_magnitudes(x))
    if inf(x)
        seq = vcat(seq, Inf)
    end
    if nan(x)
        seq = vcat(seq, NaN, -1 .* ordinary_magnitudes(x))
    end
    if inf(x)
        if nan(x)
            seq[end-1] = Inf
            seq[end] = NaN
        else
            seq[end] = Inf
        end
    elseif nan(x)
        seq[end] = NaN
    end
    Real[seq...]
end

"""
    all_offsets(x::BinaryFloat{W,P})

offsets are 0-based
"""
function all_offsets(x::BinaryFloat{W,P}) where {W,P}
    n = CountValues(x)
    if n <= 256
        offsets = map(UInt8, collect(0:n-1))
    else
        offsets = map(UInt16, collect(0:n-1))
    end
    offsets
end

"""
    all_indices(x::BinaryFloat{W,P})

indices are 1-based
"""
function all_indices(x::BinaryFloat{W,P}) where {W,P}
    n = CountValues(x)
    if n < 256
        indices = map(Int8, collect(1:n))
    else
        indices = map(Int16, collect(1:n))
    end
    indices
end


function offsets_and_values(x::UnsignedFloat{W,P}) where {W,P}
    values = all_values(x)
    offsets = all_offsets(x)
    offset2value = Dictionary(offsets, values)
    value2offset = Dictionary(values, offsets)
    (offset2value, value2offset)
end

function indicies_and_values(x::UnsignedFloat{W,P}) where {W,P}
    values = all_values(x)
    indices = all_indices(x)
    index2value = Dictionary(indices, values)
    value2index = Dictionary(values, indicess)
    (index2value, value2index)
end

function all_values(x::UnsignedFloat{W,P}) where {W,P}
    n = n_values(x)
    iszero(n) && return copy(NoValues)
    seq = magnitudes(x)
    if nan(x)
        push!(seq, NaN)
    end
    Real[seq...]
end

function all_values(x::SignedFloat{W,P}) where {W,P}
    n = n_values(x)
    iszero(n) && return copy(NoValues)
    nonnegseq = magnitudes(x)
    if nan(x)
        Real[vcat(nonnegseq, NaN, NegOne .* nonnegseq[2:end])...]
    else
        throw(ErrorException("SignedFloats should have NaN"))
    end
end

function all_significand_values(x::UnsignedFloat{W,P}) where {W,P}
    n = n_values(x)
    iszero(n) && return copy(NoValues)
    seq = significand_magnitudes(x)
    if nan(x)
        push!(seq, NaN)
    end
    Real[seq...]
end

function all_significand_values(x::SignedFloat{W,P}) where {W,P}
    n = n_values(x)
    iszero(n) && return copy(NoValues)
    nonnegseq = significand_magnitudes(x)
    if nan(x)
        Real[vcat(nonnegseq, NaN, NegOne .* nonnegseq[2:end])...]
    else
        throw(ErrorException("SignedFloats should have NaN"))
    end
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


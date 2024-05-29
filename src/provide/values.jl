function offsets_and_values(x::T) where {W,P,T<:UnsignedBinaryFloat{W,P}}
    values = all_values(x)
    offsets = all_offsets(x)
    offset2value = Dictionary(offsets, values)
    value2offset = Dictionary(values, offsets)
    (offset2value, value2offset)
end

all_significand_absvalues(x::T) where {W,P,T<:UnsignedBinaryFloat{W,P}} =
   map(abs, all_significand_values(x))

function all_significand_values(x::T) where {W,P,T<:UnsignedBinaryFloat{W,P}}
    n = n_values(x)
    iszero(n) && return copy(NoValues)
    seq = significand_magnitudes(x)
    if nan(x)
        push!(seq, NaN)
    end
    Real[seq...]
end

function all_significand_values(x::T) where {W,P,T<:SignedBinaryFloat{W,P}}
    n = n_values(x)
    iszero(n) && return copy(NoValues)
    nonnegseq = significand_magnitudes(x)
    if nan(x)
        Real[vcat(nonnegseq, NaN, NegOne .* nonnegseq[2:end])...]
    else
        throw(ErrorException("SignedFLOATs should have NaN"))
    end
end

function all_exponent_values(x::T) where {W,P,T<:BinaryFloat{W,P}}
    vals = all_values(x)
    sigvals = all_significand_values(x)
    exponents = Vector{Real}(undef, n_values(x))
    rational_idxs = map(x->isa(x, Rational), all_values(x))
    nonrational_idxs = map(x -> !isa(x, Rational), all_values(x))
    rational_idxs[1] = 0
    nonrational_idxs[1] = 0
    exponents[1] = vals[1]
    if !iszero(sum(rational_idxs))
        exponents[rational_idxs] .= vals[rational_idxs] .// sigvals[rational_idxs]
    end
    if !iszero(sum(nonrational_idxs))
        exponents[nonrational_idxs] .= vals[nonrational_idxs]
    end
    exponents
end

function all_sign_values(x::T) where {W,P,T<:UnsignedBinaryFloat{W,P}}
    fill(0, n_values(x))
end

function all_sign_values((x::T) where {W,P,T<:SignedBinaryFloat{W,P}}
    vcat( fill(0, n_values(x)>>1), fill(1, n_values(x)>>1) )
end

"""
    all_offsets(x::BinaryFloat{W,P})

offsets are 0-based
"""
function all_offsets(x::T) where {W,P,T<:UnsignedBinaryFloat{W,P}}
    n = CountValues(x)
    if n <= 256
        offsets = map(UInt8, collect(0:n-1))
    else
        offsets = map(UInt16, collect(0:n-1))
    end
    offsets
end


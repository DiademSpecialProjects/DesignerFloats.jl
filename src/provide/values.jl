function valueseq(x::UnsignedFloat{W,P}) where {W,P}
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
    seq
end

function valueseq(x::SignedFloat{W,P}) where {W,P}
    n = Count(x)
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
    seq
end

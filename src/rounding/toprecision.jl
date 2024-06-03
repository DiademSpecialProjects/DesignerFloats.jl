round_to_precision(x::T; rnd::RoundingMode=RoundNearest) where {W,P,T<:BinaryFloat{W,P}} =
    round_to_precision(value(x), precision(x), exponent_bias(x), rnd)

function round_to_precision(z::AbstractFloat, precision::Integer, bias::Integer, rnd::RoundingMode)
    # round to (precision, bias) in Reals
    if iszero(z) || isinf(z)
        return z
    end
    eta = max(floor(log2(abs(z))), 1-bias) - precision - 1
    mu = abs(z) * 2.0^(-eta)
    # round mu to integer I according to rnd
    iota = floor(Int, mu)
    delta = mu - iota
    if (rnd == RoundNearest && # RoundNearestTTE
        ((delta > 0.5) || (delta == 0.5 && isodd(iota)))) ||
       (rnd == RoundNearestTiesAway && (delta >= 0.5)) ||
       (rnd == RoundUp && z > 0 && delta > 0) ||
       (rnd == RoundDown && z < 0 && delta > 0)
    then
        iota += 1
    end
    # reconstruct from rounded iota
    return sign(z) * iota * 2.0^eta
end


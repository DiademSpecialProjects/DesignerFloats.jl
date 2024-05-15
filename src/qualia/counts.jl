# concrete counts

Count(x::BinaryFloat{W,P}) where {W,P} = Count(typeof(x))

CountExps(x::BinaryFloat{W,P}) where {W,P} = CountExps(typeof(x))

CountSignificances(x::BinaryFloat{W,P}) where {W,P} = CountSignificances(typeof(x))

"""
    CountNumbers(x::BinaryFloat{W,P})

counts the distinct values of x ignoring NaN
- the number of numeric value encodings
"""
CountNumbers

"""
    CountFinite(x::BinaryFloat{W,P})

counts the distinct values of x ignoring Infs, NaN
- the number of finite value encodings
"""
CountFinite

"""
    CountOrdinaries(x::BinaryFloat{W,P})

counts the distinct values of x ignoring Infs, NaN, Zero
- the number of ordinary value encodings
"""
CountOrdinaries

"""
    CountSpecials(x::BinaryFloat{W,P})

counts Zero, NaN, Infs
"""
CountSpecials

CountNumbers(x::UnsignedFloat{W,P}) where {W,P} =
    Count(x) - nan(x)

CountNumbers(x::SignedFloat{W,P}) where {W,P} =
    Count(x) - nan(x)

CountFinite(x::UnsignedFloat{W,P}) where {W,P} =
    Count(x) - nan(x) - inf(x)

CountFinite(x::SignedFloat{W,P}) where {W,P} =
    Count(x) - nan(x) - 2inf(x)

CountOrdinaries(x::UnsignedFloat{W,P}) where {W,P} =
    CountFinite(x) - 1 # Zero is Special, not Ordinary

CountOrdinaries(x::SignedFloat{W,P}) where {W,P} =
    CountFinite(x) - 1 # Zero is Special, not Ordinary

CountOrdinaryMagnitudes(x::UnsignedFloat{W,P}) where {W,P} =
    CountOrdinaries(x)

CountOrdinaryMagnitudes(x::SignedFloat{W,P}) where {W,P} =
    CountOrdinaries(x) >> 1

CountSpecials(x::UnsignedFloat{W,P}) where {W,P} =
    1 + nan(x) + inf(x) # Zero is Special and omnipresent

CountSpecials(x::SignedFloat{W,P}) where {W,P} =
    1 + nan(x) + 2inf(x) # Zero is Special and omnipresent


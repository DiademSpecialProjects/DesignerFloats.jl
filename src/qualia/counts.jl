# abstract counts

"""
    Count(x::BinaryFloat{W,P})

counts the distinct values of x
- the number of encodings
"""
Count(x::BinaryFloat{W,P}) where {W,P} = 2^Width(x)

# concrete counts

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
    CountOrdinary(x::BinaryFloat{W,P})

counts the distinct values of x ignoring Infs, NaN, Zero
- the number of ordinary value encodings
"""
CountOrdinary

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

CountOrdinary(x::UnsignedFloat{W,P}) where {W,P} =
    CountFinite(x) - 1 # Zero is Special, not Ordinary

CountOrdinary(x::SignedFloat{W,P}) where {W,P} =
    CountFinite(x) - 1 # Zero is Special, not Ordinary

CountSpecials(x::UnsignedFloat{W,P}) where {W,P} =
    1 + nan(x) + inf(x) # Zero is Special and omnipresent

CountSpecials(x::SignedFloat{W,P}) where {W,P} =
    1 + nan(x) + 2inf(x) # Zero is Special and omnipresent


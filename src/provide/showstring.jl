const Subscript = ("₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉",
                   "₁₀", "₁₁", "₁₂", "₁₃", "₁₄", "₁₅", "₁₆")

function Base.string(x::UnsignedBinaryFloat{W,P}; withinf=true) where {W,P} 
    specials = string(withinf && has_infinity(x) ? "ᴵ" : "")
    string("UFloat", W, "p", P, specials, "(",x.value, ", ", hexstring(x.code), ")")
end

function Base.string(x::SignedBinaryFloat{W,P}; withinf=true) where {W,P} 
    specials = string(withinf && has_infinity(x) ? "ᴵ" : "")
    string("SFloat", W, "p", P, specials, "(",x.value, ", ", hexstring(x.code), ")")
end

function Base.show(io::IO, x::BinaryFloat{W,P}) where {W,P}
    str = string(x)
    print(io, str)
end

function pretty(io::IO, x::T;  withinf=true) where {W,P,T<:BinaryFloat{W,P}}
    str = string(x; withinf)
    print(io, str)
end

function pretty(x::T; withinf=true) where {W,P,T<:BinaryFloat{W,P}}
    pretty(stdout, x; withinf)
end

const ZeroStrings = ["0","00","000","0000","00000","000000","0000000","00000000",]

function hexstring(x::Unsigned)
    hexstr = string(x, base=16)
    nhexdigits = length(hexstr)
    nzeros = max(2, nextpow(2, nhexdigits)) - nhexdigits
    zs = ZeroStrings[1:nzeros]
    "0x" * zs * hexstr
end


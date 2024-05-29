const Subscript = ("₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉",
                   "₁₀", "₁₁", "₁₂", "₁₃", "₁₄", "₁₅", "₁₆")

function Base.string(x::UnsignedBinaryFloat{W,P}; withinf=true) where {W,P} 
    specials = string(withinf && inf(x) ? "ᴵ" : "")
    string("UFloat", W, "p", P, specials)
end

function Base.string(x::SignedBinaryFloat{W,P}; withinf=true) where {W,P} 
    specials = string(withinf && inf(x) ? "ᴵ" : "")
    string("SFloat", W, "p", P, specials)
end

function Base.show(io::IO, x::BinaryFloat{W,P}) where {W,P}
    str = string(x)
    print(io, str)
end

function pretty(io::IO, x::T;  withinf=true) where {W,P,T<:BinaryFloat{W,P}}
    str = string(x; withnan, withinf)
    print(io, str)
end

function pretty(x::T; withinf=true) where {W,P,T<:BinaryFloat{W,P}}
    pretty(stdout, x; withnan, withinf)
end


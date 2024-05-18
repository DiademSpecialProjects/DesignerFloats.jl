const Subscript = ("₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉",
                   "₁₀", "₁₁", "₁₂", "₁₃", "₁₄", "₁₅", "₁₆")

function Base.string(x::UnsignedFLOAT{W,P}; withnan=true, withinf=true) where {W,P} 
    specials = string((withnan && nan(x) ? "ᴺ" : ""), (withinf && inf(x) ? "ᴵ" : ""))
    string("UFloat", W, "p", P, specials)
end

function Base.string(x::SignedFLOAT{W,P}; withnan=true, withinf=true) where {W,P} 
    specials = string((withnan && nan(x) ? "ᴺ" : ""), (withinf && inf(x) ? "ᴵ" : ""))
    string("SFloat", W, "p", P, specials)
end

function Base.show(io::IO, x::BinaryFLOAT{W,P}) where {W,P}
    str = string(x)
    print(io, str)
end

function pretty(io::IO, x::T;  withnan=true, withinf=true) where {W,P,T<:BinaryFLOAT{W,P}}
    str = string(x; withnan, withinf)
    print(io, str)
end

function pretty(x::T; withnan=true, withinf=true) where {W,P,T<:BinaryFLOAT{W,P}}
    pretty(stdout, x; withnan, withinf)
end


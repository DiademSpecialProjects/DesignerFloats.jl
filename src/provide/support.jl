Base.eltype(x::AbstractVector) = Union{unique(map(typeof, x))...}

rationaltypes(x::AbstractVector) =
    filter(a -> a <: Rational, unique(map(typeof, x)))

floattype(x::AbstractVector) =
    unique(filter(a -> a <: AbstractFloat, unique(map(typeof, x))))[1]

function rationaltype(x::AbstractVector)
    idxs = map(z -> isa(z, Rational), x)
    vals = map(abs, x[idxs])
    maxnm = maximum(numerator.(vals))
    maxdn = maximum(denominator.(vals))
    mx = max(maxnm, maxdn)
    qbits = ceil(Int, log2(mx))
    qpow2 = nextpow(2, qbits)
    if qpow2 < 128
        if qpow2 <= 16
            itype = Int32
        elseif qpow2 == 32
            itype = Int64
        else
            itype = Int128
        end
    else
        itype = typeof(vals[1])
    end
    Rational{itype}
end

function retype(x::AbstractVector)
    Union{rationaltype(x),floattype(x)}
end

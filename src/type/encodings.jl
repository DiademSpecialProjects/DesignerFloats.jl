function all_encodings(::Type{T}) where {W, P, T<:AbstractBinaryFloat{W,P}}
    n = n_values(T)
    max_encoding = n - 1
    collect(Encoding(0):Encoding(max_encoding))
end

min_encoding(::Type{T}) where {W, P, T<:AbstractBinaryFloat{W,P}} =
    Encoding(0)

max_encoding(::Type{T}) where {W, P, T<:AbstractBinaryFloat{W,P}} =
    Encoding(n_values(T) - 1)

min_normal_encoding(::Type{T}) where {W, P, T<:AbstractBinaryFloat{W,P}} =

# const encodings
const encodes_zero = Encoding(0)
const encodes_tiny = Encoding(1)

# stable encodings
function encodes_max_subnormal(::Type{T}) where {W, P, T<:AbstractBinaryFloat{W,P}}
    n = n_subnormal_magnitudes(T)
    if !iszero(n)
        Encoding(n)
    else
        nothing
    end
end

function encodes_min_normal(::Type{T}) where {W, P, T<:AbstractBinaryFloat{W,P}}
    n = n_normal_magnitudes(T)
    if !iszero(n)
        Encoding(n_subnormal_magnitudes(T) + 1)
    else
        nothing
    end
end


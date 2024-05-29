encoding_sign_exponent_significand_value(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    map(Tuple, zip(encodings_signs_exponents_significands_values(T)...))

function signs_exponents_significands_values(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    numsigns = map(x -> 1 - 2 * x, all_sign_values(T))
    exponents = all_exponent_values(T)
    significands = all_significand_absvalues(T)
    values = all_values(T)
    (numsigns, exponents, significands, values)
end

function encodings_signs_exponents_significands_values(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_values(T)
    if n <= 256
        encodings = map(UInt8, collect(0:n-1))
    else
        encodings = map(UInt16, collect(0:n-1))
    end
    (encodings, signs_exponents_significands_values(T)...)  
end

for F in (:encoding_sign_exponent_significand_value,
          :signs_exponents_significands_values, 
          :encodings_signs_exponents_significands_values)
    @eval $F(x::T) where {W,P,T<:BinaryFloat{W,P}} = $F(T)
end

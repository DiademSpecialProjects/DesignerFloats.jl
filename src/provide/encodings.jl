encoding_sign_exponent_significand_value(x::T) where {W,P,T<:BinaryFloat{W,P}} =
    map(Tuple, zip(encodings_signs_exponents_significands_values(x)...))

sign_exponent_significand_value(x::T) where {W,P,T<:BinaryFloat{W,P}} =
    map(Tuple, zip(signs_exponents_significands_values(x)...))

function exponents_significands(x::T) where {W,P,T<:BinaryFloat{W,P}}
    exponents = all_exponent_values(x)
    significands = all_absignificand_values(x)
    (exponents, significands)
end

function exponents_signedsignificands(x::T) where {W,P,T<:BinaryFloat{W,P}}
    exponents = all_exponent_values(x)
    significands = all_significand_values(x)
    (exponents, significands)
end

function signbits_exponents_significands(x::T) where {W,P,T<:BinaryFloat{W,P}}
    signs = all_sign_values(x)
    exponents = all_exponent_values(x)
    significands = all_significand_absvalues(x)
    (signs, exponents, significands)
end

function signs_exponents_significands(x::T) where {W,P,T<:BinaryFloat{W,P}}
    numsigns = map(x -> 1 - 2 * x, all_sign_values(x))
    exponents = all_exponent_values(x)
    significands = all_significand_absvalues(x)
    (numsigns, exponents, significands)
end 

function signs_exponents_significands_values(x::T) where {W,P,T<:BinaryFloat{W,P}}
    numsigns = map(x -> 1 - 2 * x, all_sign_values(x))
    exponents = all_exponent_values(x)
    significands = all_significand_absvalues(x)
    values = all_values(x)
    (numsigns, exponents, significands, values)
end

function encodings_signs_exponents_significands_values(x::T) where {W,P,T<:BinaryFloat{W,P}}
    n = n_values(x)
    if n <= 256
        encodings = map(UInt8, collect(0:n-1))
    else
        encodings = map(UInt16, collect(0:n-1))
    end
    (encodings, signs_exponents_significands_values(x)...)  
end

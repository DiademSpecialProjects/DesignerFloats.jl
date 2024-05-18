encoding_sign_exponent_significand_value(x::BinaryFloat{W,P}) where {W,P} =
    map(Tuple, zip(encodings_signs_exponents_significands_values(x)...))

sign_exponent_significand_value(x::BinaryFloat{W,P}) where {W,P} =
    map(Tuple, zip(signs_exponents_significands_values(x)...))

function exponents_and_significands(x::BinaryFloat{W,P}) where {W,P}
    exponents = all_exponent_values(x)
    significands = all_significand_values(x)
    (exponents, significands)
end

function signbits_exponents_and_significands(x::BinaryFloat{W,P}) where {W,P}
    signs = all_sign_values(x)
    exponents = all_exponent_values(x)
    significands = all_significand_values(x)
    (signs, exponents, significands)
end

function signs_exponents_significands(x::BinaryFloat{W,P}) where {W,P}
    numsigns = map(x -> 1 - 2 * x, all_sign_values(x))
    exponents = all_exponent_values(x)
    significands = all_significand_values(x)
    (numsigns, exponents, significands)
end 

function exponents_signedsignificands(x::BinaryFloat{W,P}) where {W,P}
    numsigns, exponents, significands = signs_exponents_and_significands(x)
    signedsignificands = map((a,b)->copysign(a,b), significands, numsigns)
    (exponents, signedsignificands)
end

function signs_exponents_significands_values(x::BinaryFloat{W,P}) where {W,P}
    numsigns = map(x -> 1 - 2 * x, all_sign_values(x))
    exponents = all_exponent_values(x)
    significands = all_significand_values(x)
    values = all_values(x)
    (numsigns, exponents, significands, values)
end

function encodings_signs_exponents_significands_values(x::BinaryFloat{W,P}) where {W,P}
    n = n_values(x)
    if n <= 256
        encodings = map(UInt8, collect(1:n))
    else
        encodings = map(UInt16, collect(1:n))
    end
    (encodings, signs_exponents_significands_values(x)...)  
end

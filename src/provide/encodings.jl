function exponents_and_significands(x::BinaryFloat{W,P}) where {W,P}
    exponents = all_exponent_values(x)
    significands = all_significand_values(x)
    (exponents, significands)
end

function signs_exponents_and_significands(x::BinaryFloat{W,P}) where {W,P}
    signs = all_sign_values(x)
    exponents = all_exponent_values(x)
    significands = all_significand_values(x)
    (signs, exponents, significands)
end

function exponents_and_signed_significands(x::BinaryFloat{W,P}) where {W,P}
    signs = (all_sign_values(x) .* 2) .- 1
    exponents = all_exponent_values(x)
    significands = all_significand_values(x)
    signedsignificands = map((a,b)->copysign(a,b), significands, signs)
    (exponents, signedsignificands)
end



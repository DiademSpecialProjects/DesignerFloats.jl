function exponents_and_significands(x::UnsignedFloat{W,P}) where {W,P}
    exponents, trailing_significands = exponents_and_trailing_significands(x)
    significands = copy(trailing_significands)
    n = n_subnormal_significands(x)
    if !iszero(n)

end

function exponents_and_trailing_significands(x::BinaryFloat{W,P}) where {W,P}
    offsets, values = offsets_and_values(x)
    exponents = offsets .>> TrailingSignificandBits(x)
    trailing_significands = (offsets .<< ExpBits(x)) .>> ExpBits(x)
    (exponents, trailing_significands)
end



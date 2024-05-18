function prettytable(x::BinaryFloat{W,P}) where {W,P}
    vecs= [encodings_signs_exponents_significands_values(x)...]
    df = DataFrame(vecs, [:encoding, :sign, :exponent, :significand, :value])

    fmt1(v,i,j)=(j==1 ? string("0x",@sprintf("%02x",v)) : v)
    fmt3(v,i,j)=(j>=3 && isa(v,Rational) ? string(numerator(v),"/",denominator(v)) : v)

    pretty_table(df, formatters=(fmt1,fmt3))
end


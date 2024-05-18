function prettytable(x::BinaryFLOAT{W,P}) where {W,P}
    vecs = [encodings_signs_exponents_significands_values(x)...]
    #header = [:encoding, :sign, :exponent, :significand, :value]
    header = [:hex, :sign, :exp, :sig, :value]
    alignment = [:c, :r, :r, :r, :r]
    df = DataFrame(vecs, header)
    arr = Any[]
    mp = (map(x -> Any[x...], map(values, rowtable(df))))
    for row in mp
        push!(arr, row...)
    end
    data = collect(transpose(reshape(arr, 5,n_values(x))))

    fmt1(v,i,j)=(j==1 ? string("0x",@sprintf("%02x",v)) : v)
    fmt3(v,i,j)=(j>=3 && isa(v,Rational) ? string(numerator(v),"/",denominator(v)) : v)

    pretty_table(data; formatters=(fmt1,fmt3), header, alignment)
end



all_vals(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = [all_signs(T), all_exponents(T), all_significands(T), all_values(T), float.(all_values(T))]

df(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = DataFrame(all_vals(T); [:sign, :exp, :sig, :exact, :float])


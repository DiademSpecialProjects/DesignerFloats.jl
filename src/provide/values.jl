function offsets_and_values(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    values = all_values(T)
    offsets = all_offsets(T)
    offset2value = Dictionary(offsets, values)
    value2offset = Dictionary(values, offsets)
    (offset2value, value2offset)
end

all_significand_absvalues(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
   map(abs, all_significand_values(T))

function all_sign_values(::Type{T}) where {W,P,T<:UnsignedBinaryFloat{W,P}}
    fill(0, n_values(T))
end

function all_sign_values(::Type{T}) where {W,P,T<:SignedBinaryFloat{W,P}}
    vcat( fill(0, n_values(T)>>1), fill(1, n_values(T)>>1) )
end

function all_signs(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    2 .* (1 .- all_sign_values(T)) .- 1
end

"""
    all_offsets(::BinaryFloat{W,P})

offsets are 0-based
"""
function all_offsets(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_values(T)
    if n <= 256
        offsets = map(UInt8, collect(0:n-1))
    else
        offsets = map(UInt16, collect(0:n-1))
    end
    offsets
end


for F in (:offsets_and_values, :all_significand_absvalues, 
          :all_sign_values, :all_signs, :all_offsets)
    @eval $F(x::T) where {W,P,T<:BinaryFloat{W,P}} = $F(T)
end


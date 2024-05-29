
function subnormal_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    iszero(n_subnormal_significands(T)) && return Real[]
    vcat(collect(subnormal_significand_range(T)) * collect(subnormal_exponent_range(T))' ...)
end

function normal_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    iszero(n_normal_significands(T)) && return Real[]
    vcat(collect(normal_significand_range(T)) * collect(normal_exponent_range(T))' ...)
end

max_ordinary_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    vcat(subnormal_magnitudes(T), normal_magnitudes(T))

max_finite_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    vcat(0//1, subnormal_magnitudes(T), normal_magnitudes(T))

function magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    mags = Real[max_finite_magnitudes(T)...]
    if has_infinity(T)
        mags[end] = 1//0
    end
    mags
end
all_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} = magnitudes(T)

function all_values(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    mags = magnitudes(T)
    if is_signed(T)
        negmags = Real[-1 .* mags...]
        negmags[1] = NaN
        vals = vcat(mags, negmags)
    else
        vals = mags
        if has_infinity(T)
            vals[end-1] = 1//0
        end
        vals[end] = NaN
    end
    vals
end

for F in (:subnormal_magnitudes, :normal_magnitudes, :max_ordinary_magnitudes,
           :max_finite_magnitudes, :magnitudes, :all_magnitudes, :all_values)
    @eval $F(x::T) where {W,P,T<:BinaryFloat{W,P}} = $F(T)
end

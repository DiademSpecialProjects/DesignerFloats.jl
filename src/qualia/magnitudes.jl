
"""
    all_exponents(::Type{T})

provides the exponent magnitudes in ascending order, with repetitions.
- IMPORTANT: this is the not the same as `all_exponent_magnitudes`, which has no repetitions.

[`all_exponent_magnitudes`](@ref)
"""
function all_exponents(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    subnormal_exponents = all_subnormal_exponents(T)
    normal_exponents = all_normal_exponents(T)
    vcat(subnormal_exponents, normal_exponents)
end

function all_subnormal_exponents(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n_subnormals = n_subnormal_significands(T)
    iszero(n_subnormals) && return NoValues()
    minexp = min_exponent(T)
    fill(minexp, n_subnormals)
end

function all_normal_exponents(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n_subnormal_mags = n_subnormal_significands(T)
    n_normal_mags = n_normal_magnitudes(T)
    exps = 
    n_special_mags = n_special_magnitudes(T)
end

"""
    all_exponent_magnitudes(::Type{T})

provides the exponent magnitudes in ascending order, without repetitions.
- IMPORTANT: this is the not the same as `all_exponents`, which has repetitions.

[`all_exponents``](@ref)
"""
function all_exponent_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    result = finite_exponent_magnitudes(T)
    if has_infinity(T)
        push!(result, PosInf)
    end
    result
end

function ordinary_exponent_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    subnormals = collect(subnormal_exponent_range(T))
    normals = collect(normal_exponent_range(T))
    #if !isempty(normals)
    #    normals = hcat(fill(normals, cld(n_normal_magnitudes(T), n_normal_exponents(T)))...)
    #    normals = vcat(normals'...)
    #end
    vcat(subnormals, normals)
end

function finite_exponent_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    vcat(Zero, ordinary_exponent_magnitudes(T))
end

function ordinary_significand_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    subnormals = collect(subnormal_significand_range(T))
    normals = collect(normal_significand_range(T))
    #if !isempty(normals)
    #    normals = vcat(fill(normals, cld(n_normal_magnitudes(T), n_normal_significands(T)))...)
    #end
    vcat(subnormals, normals)
end

function finite_significand_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    vcat(Zero, ordinary_significand_magnitudes(T))
end

function all_significand_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    result = finite_significand_magnitudes(T)
    if has_infinity(T)
        push!(result, PosInf)
    end
    result
end

function ordinary_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
   vcat(subnormal_magnitudes(T), normal_magnitudes(T))
end

function finite_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    vcat(Zero, ordinary_magnitudes(T))
end

function all_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    result = finite_magnitudes(T)
    if has_infinity(T)
        push!(result, PosInf)
    end
    result
end

exponent_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    collect(normal_exponent_range(T))

significand_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    collect(normal_significand_range(T))

function subnormal_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    iszero(n_subnormal_significands(T)) && return Real[]
    vcat(collect(subnormal_significand_range(T)) * collect(subnormal_exponent_range(T))' ...)[1:n_subnormal_magnitudes(T)]
end

function normal_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    iszero(n_normal_significands(T)) && return Real[]
    vcat(collect(normal_significand_range(T)) * collect(normal_exponent_range(T))' ...)[1:n_normal_magnitudes(T)]
end

max_ordinary_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    vcat(subnormal_magnitudes(T), normal_magnitudes(T))

max_finite_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}} =
    vcat(0//1, subnormal_magnitudes(T), normal_magnitudes(T))

function all_exponent_values(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    mags = all_exponent_magnitudes(T)
    if is_signed(T)
        neghalf = copy(mags)
        neghalf[1] = 0 # for NaN value
        vals = vcat(mags, neghalf)
    else
        vals = mags
        push!(vals, 0//1) # for NaN
    end
    vals
end

function all_significand_values(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    mags = Real[all_significand_magnitudes(T)...]
    if is_signed(T)
        negmags = Real[-1 .* mags...]
        negmags[1] = NaN
        vals = vcat(mags, negmags)
    else
        vals = mags
        push!(vals, NaN)
    end
    vals
end

function all_values(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    mags = Real[all_magnitudes(T)...]
    if is_signed(T)
        negmags = Real[-1 .* mags...]
        negmags[1] = NaN
        vals = vcat(mags, negmags)
    else
        vals = mags
        push!(vals, NaN)
    end
    vals
end

for F in (:subnormal_magnitudes, :normal_magnitudes, :max_ordinary_magnitudes,
          :max_finite_magnitudes, :significand_magnitudes, :exponent_magnitudes,
          :ordinary_significand_magnitudes, :ordinary_exponent_magnitudes,
          :finite_significand_magnitudes, :finite_exponent_magnitudes,
          :all_significand_magnitudes, :all_exponent_magnitudes, :all_magnitudes,
          :all_significand_values, :all_exponent_values, :all_values)
    @eval $F(x::T) where {W,P,T<:BinaryFloat{W,P}} = $F(T)
end


"""
    all_exponents(::Type{T})

provides the exponent magnitudes in ascending order, with repetitions.
- IMPORTANT: this is the not the same as `all_exponent_magnitudes`, which has no repetitions.

[`all_exponent_magnitudes`](@ref)
"""
function all_exponents(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    subnormal_exps = subnormal_exponent_magnitudes(T)
    normal_exps = normal_exponents(T)
    return append!(subnormal_exps, normal_exps)
end

"""
    all_exponent_magnitudes(::Type{T})

provides the exponent magnitudes in ascending order, with repetitions.
- IMPORTANT: this is the not the same as `all_exponents`, which has repetitions.

[`all_exponents`](@ref)
"""
function all_exponent_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    exps = vcat(Zero, ordinary_exponent_magnitudes(T))
    if has_infinity(T)
        exps = append!(exps, PosInf)
    end    
    exps
end

"""
    all_exponent_magnitudes(::Type{T})

provides the exponent magnitudes in ascending order, without repetitions.
- IMPORTANT: this is the not the same as `all_exponents`, which has repetitions.

[`all_exponents``](@ref)
"""
function all_exponent_magnitudes1(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    result = finite_exponent_magnitudes(T)
    if has_infinity(T)
        push!(result, PosInf)
    end
    result
end

function finite_exponent_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    pushfirst!(ordinary_exponent_magnitudes(T), Zero)s
end

function ordinary_exponent_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_ordinary_magnitudes(T)
    subnormal_exps = subnormal_exponent_magnitudes(T)
    normal_exps = normal_exponent_magnitudes(T)
    return append!(subnormal_exps, normal_exps)
end

function finite_significand_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    return vcat(Zero, ordinary_significand_magnitudes(T))
end

function ordinary_significand_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    subnormals = subnormal_significand_magnitudes(T)
    normals = normal_significand_magnitudes(T)
    return append!(subnormals, normals)
end

function all_significand_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    result = finite_significand_magnitudes(T)
    if has_infinity(T)
        vcat(result, PosInf)
    end
    result
end

function subnormal_significand_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_subnormal_significands(T)
    iszero(n) && return NoValues()
    return subnormal_significand_range(T)[1:n]
end

function normal_significand_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n = n_normal_magnitudes(T)
    iszero(n) && return NoValues()

    nsigs = n_normal_significands(T)
    reps = cld(n, nsigs)
    sigs = normal_significand_range(T)
    if reps > 1
        sigs = collect(Iterators.flatten(fill(sigs, reps)))
    end
    sigs[1:n]
end

function subnormal_exponent_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    iszero(n_subnormal_significands(T)) && return NoValues()
    n = n_ordinary_magnitudes(T)
    nsubnormals = n_subnormal_magnitudes(T)
    nsubnormal_exps = n_subnormal_exponents(T)
    subnormal_exps = iszero(nsubnormal_exps) ? NoValues() : subnormal_exponent_range(T)
    subnormal_reps = nsubnormals
    if !iszero(nsubnormal_exps) && subnormal_reps > 1
        subnormal_exps = collect(Iterators.flatten(fill(subnormal_exps, subnormal_reps)))
    end
    subnormal_exps[1:nsubnormals]
end
#=
function subnormal_exponent_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    n_subnormals = n_subnormal_magnitudes(T)
    iszero(n_subnormals) && return NoValues()
    minexp = min_exponent(T)
    fill(minexp, n_subnormals)
end
=#
function normal_exponent_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    iszero(n_normal_significands(T)) && return NoValues()
    nnormals = n_normal_magnitudes(T)
    nnormalexps = n_normal_exponents(T)
    reps = cld(nnormals, nnormalexps)
    subnormals = collect(subnormal_exponent_range(T))
    normals = collect(normal_exponent_range(T))
    if !isempty(normals) && reps > 1
        normals = collect(Iterators.flatten(fill(normals, reps)))
    end
    normals[1:nnormals]
end
#=

function normal_exponent_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    nnormals = n_normal_magnitudes(T)
    iszero(nnormals) && return NoValues()

    nnormal_exps = n_normal_exponent_magnitudes(T)
    normal_exps = normal_exponent_magnitudes(T)
    reps = cld(nnormals, nnormal_exps)
    if reps > 1
        normal_exps = fill(normal_exps, reps)
    end
    return normal_exps[1:nnormals]
end
=#

function ordinary_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
   return append!(subnormal_magnitudes(T), normal_magnitudes(T))
end

function finite_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    return pushfirst!(ordinary_magnitudes(T), Zero)
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
    iszero(n_subnormal_significands(T)) && return NoValues()
    subnormal_significand_magnitudes(T) .* subnormal_exponent_magnitudes(T)
end

function normal_magnitudes(::Type{T}) where {W,P,T<:BinaryFloat{W,P}}
    iszero(n_normal_significands(T)) && return NoValues()
    normal_significand_magnitudes(T) .* normal_exponent_magnitudes(T)
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
        vals = append!(mags, neghalf)
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
        vals = append!(mags, negmags)
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
        vals = append!(mags, negmags)
    else
        vals = mags
        push!(vals, NaN)
    end
    vals
end

for F in (:subnormal_magnitudes, :normal_magnitudes, :max_ordinary_magnitudes,
          :max_finite_magnitudes, :significand_magnitudes, :exponent_magnitudes,
          :subnormal_significand_magnitudes, :subnormal_exponent_magnitudes,
          :normal_significand_magnitudes, :normal_exponent_magnitudes,
          :ordinary_significand_magnitudes, :ordinary_exponent_magnitudes,
          :finite_significand_magnitudes, :finite_exponent_magnitudes,
          :all_significand_magnitudes, :all_exponent_magnitudes, :all_magnitudes,
          :all_significand_values, :all_exponent_values, :all_values)
    @eval $F(x::T) where {W,P,T<:BinaryFloat{W,P}} = $F(T)
end

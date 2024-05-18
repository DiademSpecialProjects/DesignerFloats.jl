is_signed(x::UnsignedFloat{W,P}) where {W,P} = false
is_signed(x::SignedFloat{W,P}) where {W,P} = true

is_unsigned(x::UnsignedFloat{W,P}) where {W,P} = true
is_unsigned(x::SignedFloat{W,P}) where {W,P} = false

has_subnormal_values(x::BinaryFloat{W,P}) where {W,P} = !iszero(n_subnormal_magnitudes(x))
has_normal_values(x::SignedFloat{W,P}) where {W,P} = !iszero(n_normal_magnitudes(x))


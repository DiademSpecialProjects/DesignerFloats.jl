using FastFloats, Test

for W in 2:10
    sfssym = Symbol(string("sf",W,"s"))
    @eval $sfssym = []
    for P in 1:W
        sym = Symbol(string("sf", W, P))
        @eval $sym = SimpleFloat{$W,$P}
        @eval push!($sfssym, $sym)
    end
end

@test 1 == 1

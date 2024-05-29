using CSV

minwidth = 2
maxwidth = 4

results = []

for width in minwidth:maxwidth
  for prec in 1:width-1
     xs = SignedFloat{width,prec}
     xu = UnsignedFloat{width,prec}
     fu = FiniteUnsignedFloat{width,prec}
     fs = FiniteSignedFloat{width,prec}
     xsv = all_values(xs)
     xuv = all_values(xu)
     fuv = all_values(fu)
     fsv = all_values(fs)
     res = (; width, prec, xsv, fsv, xuv, fuv)
     push!(results, res)
  end
end



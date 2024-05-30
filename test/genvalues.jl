using CSV, Tables, DataFrames, PrettyTables, LaTeXStrings, Latexify

destpath = realpath(joinpath(s"C:/temp","P3109"))

minwidth = 2
maxwidth = 11

results = []

for width in minwidth:maxwidth
  for prec in 1:width-1
    println("$width $prec")
     xs = SignedFloat{width,prec}
     xu = UnsignedFloat{width,prec}
     fu = FiniteUnsignedFloat{width,prec}
     fs = FiniteSignedFloat{width,prec}
     xsv = all_values(xs)
     xuv = all_values(xu)
     fuv = all_values(fu)
     fsv = all_values(fs)
     basename = string("Binary",width,"p",prec)
     names = Tuple(Symbol.(["width","prec","si"*basename, "sf"*basename, "ui"*basename, "uf"*basename ]))
     res = NamedTuple{names}((width, prec, xsv, fsv, xuv, fuv))
     push!(results, res)
  end
end



function prettytable(x::T; target=:text) where {W,P,T<:BinaryFloat{W,P}}
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
    fmt4(v,i,j)=(j>=3 && isa(v,Rational) ? string("\\frc{",numerator(v),"}{",denominator(v),"") : v)

    if target != :latex
       pretty_table(data; formatters=(fmt1,fmt4), header, alignment)
    else
       pretty_table(String,data; formatters=(fmt1,fmt3), header, alignment; backend=Val(:latex))
    end
end

function latextable(x::T) where {W,P,T<:BinaryFloat{W,P}}
    conf = prettyconf()
    prettytable(x; target=:latex)
end

function prettyconf(target=:latex)
    # use: pretty_table_with_conf(conf, args...; kwargs...)
    conf = set_pt_conf(;backend=Val(target), )
end
#=
#   latex backend for prettytable
=#

const LString = Union{LaTeXString, String}

function latexfrac(numer, denom)
    prettynumer = mathsf(numer)
    prettydenom = mathsf(denom)
    prettyfraction = LaTeXString(string("\\frac{",prettynumer,"}{",prettydenom,"}"))
    latexify(prettyfraction)
end

function latexfraction(numer, denom)
    prettynumer = mathsf(numer)
    prettydenom = mathsf(denom)
    prettyfraction = LaTeXString(string("\\frc{",prettynumer,"}{",prettydenom,"}"))
    latexify(prettyfraction)
end

Base.String(x::LaTeXString) = x.s

function latexmath(wrap::String, x::LString)
    latexify( LaTeXString( string(wrap , "{" , String(x) , "}") ) )
end 

sup(x::LString) = latexmath(string("^{", x, "}"))
sub(x::LString) = latexmath(string("_{", x, "}"))

supsup(x::LString) = sup(sup(x))
subsub(x::LString) = sub(sub(x))
supsub(x::LString) = sup(sub(x))
subsup(x::LString) = sub(sup(x))

mathtxt(x::LString) = latexmath("\\mathnormal", x)
mathrm(x::LString) = latexmath("\\mathrm", x)
mathit(x::LString) = latexmath("\\mathit", x)
mathbf(x::LString) = latexmath("\\mathbf", x)
mathsf(x::LString) = latexmath("\\mathsf", x)
mathtt(x::LString) = latexmath("\\mathtt", x)

mathcal(x::LString) = latexmath("\\mathcal", x)
mathbb(x::LString) = latexmath("\\mathbb", x)
mathfrak(x::LString) = latexmath("\\mathfral", x)

# math symbols

greek_lc_chars = vcat(Char.(0x03b1:0x03C1), Char.(0x03c3:0x03c9))
greek_lc_names = ["alpha", "beta", "gamma", "delta", "epsilon", "zeta", "eta", "theta", "iota", "kappa", "lambda", "mu", "nu", "xi", "omicron", "pi", "rho", "sigma", "tau", "upsilon", "phi", "chi", "psi", "omega"];
greek_lc_maths = LaTeXString.(string.("\\", greek_lc_names));
greek_lc = Dictionary(greek_lc_chars, greek_lc_maths);

macro greeklc(chr)
    tempstr = string("'", chr, "'")
    greek_lc[tempstr[2]]
end

# latex_packages = ["amsmath", "amsfonts", "amssymb", "amsthm", "bm", "mathrsfs", "mathtools", "mathdots", "unicode-math"]
latex_packages = ["tabularray", "booktabs", "enumitem", "xspace", "xfrac"]

preamble = """
\\usepackage{microtype}%

\\usepackage{ragged2e}%

\\usepackage{graphicx}%

\\usepackage{tabularray}%

\\usepackage{booktabs}%
% more space between rows%
\\renewcommand{\\arraystretch}{1.325}%
%
\\usepackage{xfrac}%
\\newcommand{\\frc}[2]{{\\ensuremath{\\mathbf{\\sfrac{#1}{#2}}}}}%

\\newcommand{\\NaN}[0]{\\small{\\textsc{\\textsf{NaN}}}}%
\\newcommand{\\nan}[0]{\\footnotesize{\\textsc{\\textsf{NaN}}}}%
"""

#=
\documentclass{article}

\input{ieeesa_styles.tex}

\title{Small Floats (2..4 bits)\\
\Large{signed and unsigned values}}

\author{Jeffrey Sarnoff}
\date{\today\\\emph{ver 0.1}}


\begin{document}

\clearpage
\section{Tables}

\subsection{Unsigned 2-bit floats}
\vspace{1ex}

\begin{table}[hbt]
    \begin{tabular}{ccc}
         
\begin{minipage}{.3\textwidth}
\centering
\begin{tabular}{@{}ccr@{}} \toprule
\multicolumn{3}{c}{uBinary2p1} \\ \cmidrule(r){1-3}
encoded & rational & float \\ \midrule
{0x00} & {\frc{0}{1}} & {$0.0$} \\
{0x01} & {\frc{1}{2}} & {$0.5$} \\
{0x02} & {\frc{1}{1}} & {$1.0$} \\
{0x03} & {\frc{2}{1}} & {\nan} \; {$2.0$}\\
\bottomrule
\end{tabular}
\end{minipage}
&
\begin{minipage}{.3\textwidth}
\centering
\begin{tabular}{@{}ccr@{}} \toprule
\multicolumn{3}{c}{uBinary2p2} \\ \cmidrule(r){1-3}
encoded & rational & float \\ \midrule
{0x00} & {\frc{0}{1}} & {$0.0$} \\
{0x01} & {\frc{1}{2}} & {$0.5$} \\
{0x02} & {\frc{1}{1}} & {$1.0$} \\
{0x03} & {\frc{3}{2}} & {\nan} \; {$1.5$}\\

\bottomrule
\end{tabular}
\end{minipage}
\\
    \end{tabular}
\end{table}

\vspace{2.5ex}




clearpage
\subsection{Signed 4-bit floats}
\vspace{1ex}

\begin{table}[hbt]
    \begin{tabular}{cccc}
         
\begin{minipage}{.22\textwidth}
\centering

\begin{tabular}{@{}cc@{}} \toprule
\multicolumn{2}{c}{Binary4p1} \\ \cmidrule(r){1-2}
encoded & rational \\ \midrule
{0x00} & {\frc{0}{1}} \\
{0x01} & {\frc{1}{8}} \\
{0x02} & {\frc{1}{4}} \\
{0x03} & {\frc{1}{2}} \\
{0x04} & {\frc{1}{1}} \\
{0x05} & {\frc{2}{1}} \\
{0x06} & {\frc{4}{1}} \\
{0x07} & {\frc{8}{1}} \\
{0x08} & {\NaN} \\
{0x09} & {\frc{-1}{8}} \\
{0x0a} & {\frc{-1}{4}} \\
{0x0b} & {\frc{-1}{2}} \\
{0x0c} & {\frc{-1}{1}} \\
{0x0d} & {\frc{-2}{1}} \\
{0x0e} & {\frc{-4}{1}} \\
{0x0f} & {\frc{-8}{1}} \\
\bottomrule
\end{tabular}
\end{minipage}
& 
\begin{minipage}{.22\textwidth}
\centering
\begin{tabular}{@{}cc@{}} \toprule
\multicolumn{2}{c}{Binary4p2} \\ \cmidrule(r){1-2}
encoded & rational \\ \midrule
{0x00} & {\frc{0}{1}} \\
{0x01} & {\frc{1}{4}} \\
{0x02} & {\frc{1}{2}} \\
{0x03} & {\frc{3}{4}} \\
{0x04} & {\frc{2}{1}} \\
{0x05} & {\frc{3}{2}} \\
{0x06} & {\frc{2}{1}} \\
{0x07} & {\frc{3}{1}} \\
{0x08} & {\NaN} \\
{0x09} & {\frc{-1}{4}} \\
{0x0a} & {\frc{-1}{2}} \\
{0x0b} & {\frc{-3}{4}} \\
{0x0c} & {\frc{-2}{1}} \\
{0x0d} & {\frc{-3}{2}} \\
{0x0e} & {\frc{-2}{1}} \\
{0x0f} & {\frc{-3}{1}} \\
\bottomrule
\end{tabular}
\end{minipage}
&         
\begin{minipage}{.22\textwidth}
\centering

\begin{tabular}{@{}cc@{}} \toprule
\multicolumn{2}{c}{Binary4p3} \\ \cmidrule(r){1-2}
encoded & rational \\ \midrule
{0x00} & {\frc{0}{1}} \\
{0x01} & {\frc{1}{4}} \\
{0x02} & {\frc{1}{2}} \\
{0x03} & {\frc{3}{4}} \\
{0x04} & {\frc{1}{1}} \\
{0x05} & {\frc{5}{4}} \\
{0x06} & {\frc{3}{2}} \\
{0x07} & {\frc{7}{4}} \\
{0x08} & {\NaN} \\
{0x09} & {\frc{-1}{4}} \\
{0x0a} & {\frc{-1}{2}} \\
{0x0b} & {\frc{-3}{4}} \\
{0x0c} & {\frc{-1}{1}} \\
{0x0d} & {\frc{-5}{4}} \\
{0x0e} & {\frc{-3}{2}} \\
{0x0f} & {\frc{-7}{4}} \\
\bottomrule
\end{tabular}
\end{minipage}
&         
\begin{minipage}{.22\textwidth}
\centering
\begin{tabular}{@{}cc@{}} \toprule
\multicolumn{2}{c}{Binary4p4} \\ \cmidrule(r){1-2}
encoded & rational \\ \midrule
{0x00} & {\frc{0}{1}} \\
{0x01} & {\frc{1}{8}} \\
{0x02} & {\frc{19}{70}} \\
{0x03} & {\frc{117}{280}} \\
{0x04} & {\frc{79}{140}} \\
{0x05} & {\frc{199}{280}} \\
{0x06} & {\frc{6}{7}} \\
{0x07} & {\frc{1}{1}} \\
{0x08} & {\NaN} \\
{0x09} & {\frc{-1}{8}} \\
{0x0a} & {\frc{-19}{70}} \\
{0x0b} & {\frc{-117}{280}} \\
{0x0c} & {\frc{-79}{140}} \\
{0x0d} & {\frc{-199}{280}} \\
{0x0e} & {\frc{-6}{7}} \\
{0x0f} & {\frc{-1}{1}} \\
\bottomrule
\end{tabular}
\end{minipage}
\\
    \end{tabular}
\end{table}


\end{document}

=#
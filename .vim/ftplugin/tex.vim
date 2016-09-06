 " this is mostly a matter of taste. but LaTeX looks good with just a bit
 " of indentation.
 set sw=2
 " TIP: if you write your \label's as \label{fig:something}, then if you
 " type in \ref{fig: and press <C-n> you will automatically cycle through
 " all the figure labels. Very useful!
 set iskeyword+=:

" let g:Tex_DefaultTargetFormat = 'pdf'
" let g:Tex_CompileRule_pdf = 'pdflatex -interaction=nonstopmode $* & biber .shellescape(expand("%")). & pdflatex -interaction=nonstopmode $*'
" let g:Tex_CompileRule_pdf = 'pdflatex -interaction=nonstopmode $* & biber *:r & pdflatex -interaction=nonstopmode $*'
" let g:Tex_CompileRule_pdf = 'pdflatex -interaction=nonstopmode $* & bibtex $* & pdflatex -interaction=nonstopmode $*'
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_CompileRule_pdf = 'arara -v $*'

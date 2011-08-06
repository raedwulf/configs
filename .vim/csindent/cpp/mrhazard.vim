" Vim indent file
" Language:	C++
" Maintainer:	Tai Chi Minh Ralph Eastwood <tcmreastwood@gmail.com>
" Last Change:	2011 July 25
" License: MIT
" Version: 1.0.0
"
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal shiftwidth=3
setlocal tabstop=3
setlocal softtabstop=3
setlocal expandtab
setlocal textwidth=80
setlocal wrap

setlocal cindent
setlocal cinoptions=l1,t0,(3,w1

" Vim syntax file
" Language: Todo
" Maintainer: Huy Tran
" Description: Syntax highlighting for Todo format

if exists("b:current_syntax")
  finish
endif

" -------------------------------------------------------------
"  Top‑level patterns
" -------------------------------------------------------------

syn match todoSeparator /^———————.*$/

syn match todoHeader /^#.*$/
syn match todoProject /^[A-Z]*$/

syn match todoWork /^\s*w\s.*$/

syn match todoPending /^\s*•\s.*$/
syn match todoPending /^\s*t\s.*$/

syn match todoBlock /^\s*b\s.*$/
syn match todoBlock /^\s*!\s.*$/

syn match todoDone /^\s*d\s.*$/
syn match todoDone /^\s*x\s.*$/

syn match todoMoved /^\s*>\s.*$/
syn match todoMoved /^\s*m\s.*$/

" -------------------------------------------------------------
"  Default highlighting links – tweak to taste
" -------------------------------------------------------------
hi def link todoHeader      Title
hi def link todoProject     Constant
hi def todoProject          gui=underline cterm=underline
hi def todoHeader           gui=bold
hi def todoWork             guifg=#27272a guibg=#fbc19d
hi def link todoPending     Todo
hi def todoBlock            guifg=#db4b4b guibg=NvimDarkRed
hi def todoDone             guifg=#839463 gui=strikethrough
hi def link todoMoved       Comment
hi def todoSeparator        guifg=#756378

let b:current_syntax = "todo"

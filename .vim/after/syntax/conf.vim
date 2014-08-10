syn keyword myTodo contained TODO
syn keyword Problem contained BUG FIXME XXX ERROR
syn keyword Done contained DONE
syn keyword Note contained NOTE

hi myTodo ctermfg=black ctermbg=yellow
hi Problem ctermfg=black ctermbg=red
hi Done ctermfg=black ctermbg=green
hi Note ctermfg=black ctermbg=blue
"hi link myTodo Todo

syn match confComment '#.*' contains=myTodo,Problem,Done,Note

syn keyword myTodo contained BUG FIXME ERROR NOTE XXX TODO DONE

hi link myTodo Todo

syn match confComment '#.*' contains=myTodo

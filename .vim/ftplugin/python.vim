" Python editing necessities
set expandtab

" Enable syntax checkers for python
let g:syntastic_python_checkers = ['pylint', 'pyflakes']

" Setup solarized colors
let g:solarized_termcolors=256
colorscheme solarized
set background=dark

" fold settings
set foldmethod=indent 	" folds based on indent level
set foldcolumn=3		" Uses 3 columns for folding display at left
set mouse=a				" allow the use of the mouse

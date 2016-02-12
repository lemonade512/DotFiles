" Khan Academy style guidelines: 4-space indents
" https://sites.google.com/a/khanacademy.org/forge/for-developers/styleguide/python
setlocal expandtab ts=4 sw=4 sts=4

" Enable syntax checkers for python
let g:syntastic_python_checkers = ['pylint', 'pyflakes']

" Setup solarized colors
"let g:solarized_termcolors=256
"colorscheme solarized
"set background=dark

" Setup color scheme
let g:zenburn_high_Contrast=1
let g:zenburn_old_Visual=1
let g:zenburn_alternate_Visual=1
colorscheme zenburn

"set foldmethod=indent

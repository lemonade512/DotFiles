set nocompatible              " be iMproved

" Package Management {{{
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/syntastic'
Plugin 'kien/ctrlp.vim'
"Plugin 'kevinw/pyflakes-vim'
"Plugin 'Raimondi/delimitMate'
Plugin 'tpope/vim-surround'
Plugin 'bling/vim-airline'
Plugin 'yueyoum/vim-linemovement'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'majutsushi/tagbar'

Plugin 'Glench/Vim-Jinja2-Syntax'

" Better starting screen
Plugin 'mhinz/vim-startify'

" Syntax hilighting for less
" TODO this stuff takes FOREVER to startup
"Plugin 'groenewege/vim-less'
"Plugin 'skammer/vim-css-color'
"Plugin 'hail2u/vim-css3-syntax'

"" Session manager
"Plugin 'xolox/vim-session'
"
"" Vim notes
"Plugin 'xolox/vim-notes'
"Plugin 'xolox/vim-misc'

" Used for javascript stuff
Plugin 'marijnh/tern_for_vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'pangloss/vim-javascript'
Plugin 'nathanaelkane/vim-indent-guides'

" Used for HTML/CSS
Plugin 'mattn/emmet-vim'

call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ

set rtp+=~/.vim/after/hack.vim
" }}}

" Package Configuration {{{
"	linemovement {{{
		let g:linemovement_up="<A-Up>"
		let g:linemovement_down="<A-Down>"
"	}}}
"	YouCompleteMe {{{
        let g:ycm_autoclose_preview_window_after_completion=1

        " Must press ctrl and an arrow key to move up and down completion
        " list
        let g:ycm_key_list_select_completion=['<TAB>', '<C-Down>']
        let g:ycm_key_list_previous_completion=['<S-TAB>', '<C_Up>']

		let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
		let g:ycm_show_diagnostics_ui = 0
		"let g:ycm_auto_trigger = 0
"	}}}
"   Syntastic {{{
        let g:syntastic_mode_map={'mode':'active','active_filetypes':[],'passive_filetypes':[]}
"   }}}
"   Airline (better status bar) {{{
		let g:airline#extensions#tabline#enabled=1
		let g:airline_powerline_fonts = 1
"   }}}
"	Notes {{{
		let g:notes_directories = ['~/Documents/Notes']
"	}}}
"	Session {{{
		let g:session_directory = '~/.vim/sessions'
		let g:session_autosave='no'
		let g:session_autoload='no'
"	}}}
"	Startify {{{
		let g:startify_session_dir = "~/.vim/sessions"
		"let g:startify_list_order = ['sessions', 'bookmarks', 'dir', 'files']
		let g:startify_list_order = [
			\ ['My Sessions:'], 'sessions',
			\ ['My Bookmarks:'], 'bookmarks',
			\ ['Most Recently Used Files:'], 'files']
		let g:startify_bookmarks = ['~/.vimrc']
		let g:startify_custom_header = [
			\ '  Always code as if the guy who ends up maintaining your code',
			\ '  will be a violent psychopath who knows where you live.',
			\ '							- Rick Osbourne',
			\ '',
			\ '']
"	}}}
"   Auto Format {{{
		let g:formatdef_yapf = '"python yapf"'
		let g:formatters_python = ['yapf']
"   }}}
"	Ctrl-P {{{
		let g:ctrlp_custom_ignore = 'node_modules'
"	}}}
" }}}

" General {{{
filetype plugin on	" Allows use of filetype plugins
set encoding=utf-8	" Sets encoding to utf-8
let mapleader=","	" Changes leader key from \ to ,
set autochdir		" automatically sets the cwd to the file being edited

" Makes it easier to use 'O' without waiting
"set timeout timeoutlen=1000 ttimeoutlen=100
set noesckeys		" Means you can't use escape keys in insert mode (but I don't need them)

" Doesn't default to plaintex
let g:tex_flavor = "latex"
" }}}

" Colors {{{
syntax enable
set t_Co=256
"colorscheme wombat256mod " set default colorscheme
colorscheme baycomb " set default colorscheme
set background=dark " set background to dark

if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif
" }}}

" Spaces and Tabs {{{
filetype indent on	" load filetype-specific indent files
set shiftwidth=4	" Number of spaces for auto indenting also effects reindent operations (<< and >>)
set tabstop=4		" A tab is 4 spaces"
set softtabstop=4	" number of spaces in tab when editing
set smarttab		" insert tabs on the start of a line according to
					"    shiftwidth, not tab stop
set autoindent		" turns on auto indentions
set listchars=tab:>.,trail:.,extends:#,nbsp:.,eol:& " set the listchars to be used for set list
" }}}

" UI Config {{{
set wrap			" Lines wrap
set linebreak		" only wrap at a character in breakat
set nolist			" list diables linebreak
set textwidth=0		" Don't insert linebreaks for wrap
set wrapmargin=0	" Don't insert linebreaks for wrap
set mouse=a			" Can use mouse for most actions
set pastetoggle=<F2> " Allow toggling paste mode with F2
set hidden			" Buffers become hidden when abandoned
set laststatus=2	" Always show status bar
set showcmd 		" shows command in bottom right
set wildmenu		" visual autocomplete for command menu
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o " ignore some files in wild menu
set lazyredraw		" only redraws when it needs to
set showmatch		" highlight matching [{()}]
set backspace=2 	" can backspace through anything
set autoread		" automatically updates file that has been changed outside of buffer
set scrolloff=2		" Always shows at least 2 lines of context when scrolling

" Disable backup and swap files
set nobackup
set nowritebackup
set noswapfile

" Remember info about open buffers on close
set viminfo^=%
" }}}

" Searching {{{
set incsearch		" searches file as you type
set ignorecase
set smartcase		" search is case insensitive if in all lowercase
set hlsearch

" searches for whatever is selected in visual mode
vnoremap <silent> * :call VisualSelection('f')<CR>
" }}}

" Folding {{{
" If you have trouble with syntax highlighting try <Ctrl-l>
set foldenable			" enable folding
set foldlevelstart=10	" open most folds by default
set foldnestmax=10		" 10 nested fold max
set foldmethod=indent

autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* if (expand("<afile>")) != "config.py" | silent loadview | endif
" TODO set a folding method for different filetypes using autocmds
" }}}

" Autogroups {{{

augroup allgroup
	autocmd!
	autocmd BufWritePre * :call DeleteTrailingWS()
	autocmd BufEnter * AirlineRefresh
	autocmd BufEnter * :lchdir %:p:h

	" Return to last edit position when opening files
	autocmd BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\	exe "normal! g`\"" |
		\ endif
augroup END

augroup configgroup
	autocmd!
	autocmd BufWritePost .vimrc source %   " Automatically reload config file when saved
	autocmd BufWritePost .vimrc set foldmethod=marker
augroup END

" Add a custom filetype for testing
au BufNewFile,BufRead *.pn set filetype=potion
" }}}

" Custom Functions {{{

func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc

" toggle between number and relativenumber and no number
function! ToggleNumber()
	if !exists("b:number_status")
		let b:number_status = 2
	endif

	if (b:number_status == 1)
		set norelativenumber
		set nonu
		let b:number_status = 2
	elseif (b:number_status == 2)
		set norelativenumber
		set number
		let b:number_status = 3
	else
		set relativenumber
		let b:number_status = 1
	endif

endfunc

function! CmdLine(str)
	exe "menu Foo.Bar :" . a:str
	emenu Foo.Bar
	unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" }}}

" General Key Mappings {{{

" Toggle Tagbar
nmap T :TagbarToggle<CR>

" Allow easy window switching
nmap <silent> <S-Up> :wincmd k<CR>
nmap <silent> <S-Down> :wincmd j<CR>
nmap <silent> <S-Left> :wincmd h<CR>
nmap <silent> <S-Right> :wincmd l<CR>

" Allow using ctl + arrow up or down to move between folds
nmap <C-Up> zk
nmap <C-Down> zj

" move vertically by visual line not real line
nnoremap j gj
nnoremap k gk
nnoremap <End> g<End>
nnoremap <Home> g<Home>
imap <End> <C-o>g<End>
imap <Home> <C-o>g<Home>

" Arrow keys are for wimps
nnoremap <Down> <nop>
nnoremap <Up> <nop>
nnoremap <Left> <nop>
nnoremap <right> <nop>
imap <Down> <nop>
imap <Up> <nop>
imap <Left> <nop>
imap <right> <nop>

" highlight last inserted text
nnoremap gV `[v`]

" maps space to open and close folds
nnoremap <space> za

" easier moving of code blocks
vnoremap < <gv
vnoremap > >gv

" Abbreviation for the time and date
iab xdate <C-r>=strftime("%c")<CR>

" Key mappings for Line dividers
imap ;ld= ==============================================================================================
imap ;ld- ----------------------------------------------------------------------------------------------
imap ;ld* **********************************************************************************************

" Template key mappings
"imap <buffer> ;; <C-O>/%%%<CR><C-O>c3l
nmap <buffer> ;; /%%%<CR>c3l

imap <buffer> ;pycls <C-O>mzclass %%%(%%%):<CR>'''<CR>%%%<CR>'''<CR><CR>def __init__(self, %%%):<CR>%%%<C-O>'z;;
imap <buffer> ;pyhead <C-O>mz#!/usr/bin/python<CR># -*- encoding: utf-8 -*-<CR>"""<CR>Created on xdate<CR><CR>%%%<CR><CR>@author: klemons<CR>"""<CR><CR>from sys import path<CR>path.append("../Linux-x86_64-swig")<CR><C-O>'z;;
imap <buffer> ;pyfunc <C-O>mzdef %%%(%%%):<CR>'''<CR>%%%<CR>'''<CR><CR>%%%<C-O>'z;;

" }}}

" Leader Key Mappings {{{

" turn off seach highlight with ,<space>
nnoremap <leader><space> :nohlsearch<CR>

" edit vimrx/bashrc and load vimrc bindings
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>ez :vsp ~/.bashrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Key-mappings to turn YouCompleteMe on and off
nnoremap <leader>y :let g:ycm_auto_trigger=0<CR>
nnoremap <leader>Y :let g:ycm_auto_trigger=1<CR>

" change tabs with ,tn and ,tm
nnoremap <leader>tn :tabp<CR>
nnoremap <leader>tm :tabp<CR>

" change buffers with ,k and ,j
nnoremap <leader>j :bp<CR>
nnoremap <leader>k :bn<CR>

" Close the current buffer
noremap <leader>bd :bp<bar>sp<bar>bn<bar>bd<CR>

" Toggle preferences
nnoremap <leader>c :call ToggleNumber()<CR>
nnoremap <leader>x :SyntasticToggleMode<CR>
nnoremap <leader>z :set list!<CR>

" Spell check stuff
nnoremap <leader>s :set spell!<CR>
nnoremap <leader>sn ]s
nnoremap <leader>sp [s
nnoremap <leader>se z=

" Quick save command
nnoremap <leader>w :call DeleteTrailingWS()<CR>:write<CR>

" Quick quit command
nnoremap <leader>q :quit<CR>

" Search and replace with <leader>r
vnoremap <silent><leader>r :call VisualSelection('replace')<CR>

" 'super save' saves an assortment of windows that can be reopened with vim -S
nnoremap <leader>ms :SaveSession<CR>
" }}}

" Allow xterm keys in tmux
if &term =~ '^screen'
	execute "set <xUp>=\e[1;*A"
	execute "set <xDown>=\e[1;*B"
	execute "set <xRight>=\e[1;*C"
	execute "set <xLeft>=\e[1;*D"
endif

" Last 5 lines are modelines
set modelines=5
" vim:foldmethod=marker:foldlevel=0

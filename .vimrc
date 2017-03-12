" vim:ts=2:sw=2:et
"
set nocompatible               " disable vi
set backspace=indent,eol,start " make backspace full functional
"
" disable Ex mode
"
nnoremap Q <Nop>    
nnoremap gQ <Nop>
"
" fix undo.
" http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
"
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
"
" restore terminal screen after quit
"
if has("terminfo")
  let &t_Sf="\ESC[3%p1%dm"
  let &t_Sb="\ESC[4%p1%dm"
else
  let &t_Sf="\ESC[3%dm"
  let &t_Sb="\ESC[4%dm"
endif
"
" do not store .swp and *~ files in working directory,
" save them into /tmp
"
silent execute '!mkdir -p "/tmp/vim-backup"'
silent execute '!mkdir -p "/tmp/vim-swap"'
silent execute '!mkdir -p "/tmp/vim-undo"'
set backupdir=/tmp/vim-backup//
set directory=/tmp/vim-swap//
set undodir=/tmp/vim-undo//
"
" display all whitespace chars with set list
" 
set listchars=eol:$,tab:>.,trail:.,extends:\#,nbsp:.
"
set backup                " do create backup files
set swapfile              " do create swap files
set undofile              " do create undo files
set history=100           " how many lines of command history to keep
set showcmd               " enable vim own command completion
set ignorecase            " ignore case if search with /,? etc.
set smartcase             " case sensitive if uppercase in search pattern
set incsearch             " highlight search term while typing
set showmatch             " show matching bracets
set nohlsearch            " do not highlight all search results
set autoindent            " indent automatically
set splitright            " vertical split focus on the right pane
set splitbelow            " horisontal split focus on the bottom pane
set hidden                " allow switch of modified buffers
set encoding=utf-8        " use utf-8 as default encoding
set mouse=a               " enable mouse in every mode
set foldlevel=20          " do not fold first 20 levels when open a file
set laststatus=2          " always show statusline
set ttimeoutlen=50        " reduce timeout between keystrokes
set t_Co=256              " force 256-colors terminal
syntax enable             " enable syntax highlighting
filetype on               " enable filetype detection
filetype plugin on        " enable filetype plugins
filetype plugin indent on " enable syntax defined indendation
"set number                " display line numbers for all files
"set cursorline            " highlight cursorline for all files
"
" colorscheme
"
set background=dark
let g:solarized_termtrans=1
colorscheme solarized

" vim-plug {{{
if empty(glob($HOME.'/.vim/autoload/plug.vim')) " Automatically install Vim-Plug if it is not yet installed
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
call plug#begin($HOME.'/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
Plug 'Shougo/neocomplete.vim'  
Plug 'weirdgiraffe/vim-template'
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'vim-syntastic/syntastic', {'for': 'python'}
Plug 'junegunn/goyo.vim'
Plug 'Valloric/YouCompleteMe', {'for': 'c,cpp'}
Plug 'rdnetto/YCM-Generator', {'for': 'c,cpp', 'branch': 'stable'}
call plug#end()
" vim-plug }}}

" vim-airline {{{
set noshowmode                                 " don't show modeline because of airline
let g:airline_powerline_fonts=1                " enable powerfonts for airline
let g:airline_theme="solarized"
let g:airline_solarized_bg="dark"
let g:airline#extensions#tabline#enabled=1     " Enable the list of buffers in a topline
let g:airline#extensions#tabline#fnamemod=':t' " Show filename only in buffer list
" vim-airline }}}

" nerdtree {{{
let g:loaded_netrw=1                           " disable netrw and use NERDTree
let g:loaded_netrwPlugin=1                     " disable netrw and use NERDTree
nnoremap <F2> :NERDTreeToggle<CR>
" F2  Display/Hide NERDTree
let NERDTreeIgnore = ['__pycache__', '\.pyc', '\.o']
" F3 Preview file when inside NERDTree  
let g:NERDTreeMapPreview="<F3>"
" nerdtree }}}

" ctrlp.vim {{{
" Filenames and directory names to ignore in ctrlp plugin
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|\.svn|\.ropeproject|\.cache|__pycache__)$',
  \ 'file': '\v(\.exe|\.lib|\.so|\.dll|\.pyc|\~)$',
  \ }
" list open buffers
nnoremap <leader>bb :CtrlPBuffer<CR>
" close current buffer but leave the window open
nnoremap <leader>bd :bp<bar>sp<bar>bn<bar>bd<CR>
" simply go to the next buffer
nnoremap <leader>bn :bn<CR>
" simply go to the previous buffer
nnoremap <leader>bp :bp<CR>
" ctrlp.vim }}}

" neocomplete.vim {{{
let g:neocomplete#enable_at_startup=1
" do some magic with autocompletion for python
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
" deafult pattern: \'[@]\?\h\w*'
let g:neocomplete#force_omni_input_patterns.python =
  \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
" neocomplete.vim }}}

" syntastic for python
"
" need to install pylama, beacuse it wraps all needed linters and checkers
" for python:    https://github.com/klen/pylama
"

" vim-go {{{
let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 1
let g:go_metalinter_autosave = 0
let g:go_gocode_unimported_packages = 0
let g:go_template_autocreate = 0
let g:go_updatetime = 800
au FileType go nmap <leader>q <Plug>(go-build)
au FileType go nmap <leader>w <Plug>(go-test)
au FileType go nmap <leader>e <Plug>(go-run)
au FileType go nmap <leader>r <Plug>(go-coverage)
" vim-go }}}

"
" to write some into some file own by root just type :w!!
"
cmap w!! w !sudo tee % >/dev/null  

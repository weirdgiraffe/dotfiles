" vim:ts=2:sw=2:et
set nocompatible                            " disable vi
set backspace=indent,eol,start              " full functional backspace

" define all kind of vim files in separate directories
" for all *nix and cygwin
if has("win32unix") || has("unix")
  silent execute '!mkdir -p "/tmp/vim-backup"'
  silent execute '!mkdir -p "/tmp/vim-swap"'
  silent execute '!mkdir -p "/tmp/vim-undo"'
  set backupdir=/tmp/vim-backup//
  set directory=/tmp/vim-swap//
  set undodir=/tmp/vim-undo//
endif

set backup                                  " create backup files
set swapfile                                " create swap files
set undofile                                " create undo files
set history=100                             " how many lines of command history to keep
set showcmd                                 " enable vim own command completion
set ignorecase                              " ignore case if search with /,? etc.
set smartcase                               " case sensitive if uppercase in search pattern
set incsearch                               " highlight search term while typing
set showmatch                               " show matching bracets
set nohlsearch                              " do not highlight all search results
set autoindent                              " indent automatically
set splitright                              " vertical split focus on the right
set splitbelow                              " horisontal split focus on the bottom
set hidden                                  " allow buffers to be hidden,
                                            " i.e switch modified buffers
set encoding=utf-8                          " essential for airline to work

" disable Ex mode because I don't use it
nnoremap Q <Nop>
nnoremap gQ <Nop>

" see http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

set mouse=a                                 " enable mouse in every mode
set foldlevel=20                            " do not fold first 20 levels when open a file
set laststatus=2                            " always show statusline
let ttimeot=50                              " reduce timeout between keystrokes
set t_Co=256                                " enable 256-colors terminal

" restore terminal screen after quit
if has("terminfo")
  let &t_Sf="\ESC[3%p1%dm"
  let &t_Sb="\ESC[4%p1%dm"
else
  let &t_Sf="\ESC[3%dm"
  let &t_Sb="\ESC[4%dm"
endif

syntax enable                               " enable syntax highlighting
filetype on                                 " enable filetype detection
filetype plugin on                          " enable filetype plugins
filetype plugin indent on                   " enable syntax defined indendation
set number                                  " display line numbers for all files
set cursorline                              " highlight cursorline for all files

" load plugins
try
  call plug#begin($HOME.'/.vim/plugged')
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'kien/ctrlp.vim'
  Plug 'scrooloose/nerdtree'
  Plug 'weirdgiraffe/vim-template'
  Plug 'junegunn/goyo.vim'
  if has("unix")
    Plug 'Shougo/neocomplete.vim'
    Plug 'vim-syntastic/syntastic'
    Plug 'fatih/vim-go'
    Plug 'Konfekt/FastFold'
    Plug 'Valloric/YouCompleteMe'
    Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
  endif
  call plug#end()
catch
  let g:loaded_plug=0
  echom "Plug is not installed"
endtry

if (g:loaded_plug)
  let g:loaded_netrw=1                      " disable netrw and use NERDTree
  let g:loaded_netrwPlugin=1                " disable netrw and use NERDTree

  if has("unix")
    let g:neocomplete#enable_at_startup=1   " enable completion on startup

    let g:ycm_filteype_whitelist = {
          \ 'c': 1,
          \ 'cpp': 1,
          \}

    " do some magic with autocompletion for python
    if !exists('g:neocomplete#force_omni_input_patterns')
      let g:neocomplete#force_omni_input_patterns = {}
    endif
    " deafult pattern: \'[@]\?\h\w*'
    let g:neocomplete#force_omni_input_patterns.python =
      \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

    " run go-imports before save
    let g:go_fmt_command = "goimports"
    let g:go_metalinter_autosave = 0
    let g:go_fmt_autosave = 1
    let g:go_gocode_unimported_packages = 0
    let g:go_template_autocreate = 0
    let g:go_updatetime = 800

    let g:py_fold_enabled = 1

    " Configure syntastic for python
    "
    " need to install pylama, beacuse it wraps all needed linters and checkers
    " for python:    https://github.com/klen/pylama
    "
  endif

  " F2  Display/Hide NERDTree
  nnoremap <F2> :NERDTreeToggle<CR>
  let NERDTreeIgnore = ['__pycache__', '\.pyc', '\.o']

  " Inside NERDTree
  "   F3 Preview file
  "   F4 Activate file
  let g:NERDTreeMapPreview="<F3>"
  let g:NERDTreeMapActivateNode="<F4>"

  " Filenames and directory names to ignore in ctrlp plugin
  let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/](\.git|\.svn|\.ropeproject|\.cache|__pycache__)$',
    \ 'file': '\v(\.exe|\.lib|\.so|\.dll|\.pyc|\~)$',
    \ }

  set background=dark
  let g:solarized_termtrans=1

  colorscheme solarized
  let g:goyo_width=90
  let g:goyo_height=90

  set noshowmode                            " dont display modeline because we have airline
  let g:airline_powerline_fonts=1           " enable powerfonts for airline

  let g:airline_theme="solarized"
  let g:airline_solarized_bg="dark"
  " Enable the list of buffers in a topline
  let g:airline#extensions#tabline#enabled=1
  " Show just the filename in buffers list
  let g:airline#extensions#tabline#fnamemod=':t'

  " in vim-templates get user email from gitconfig
  let g:username=substitute(system('git config --get user.name'), '[\r\n]*$', '', '')
  let g:email=substitute(system('git config --get user.email'), '[\r\n]*$', '', '')

else
  " if plugins are not loaded, then set statusline at least
  set ruler is                              "to display line numbers

  " left block
  set statusline=%-20t%m%r%h%w
  set statusline+=%=

  " right block
  set statusline+=%y[%{&fenc==\"\"?&enc:&fenc},%{&ff}]\ %-3v:%4l\

  hi StatusLine ctermbg=15 ctermfg=10
endif

au FileType go nmap <leader>q <Plug>(go-build)
au FileType go nmap <leader>w <Plug>(go-test)
au FileType go nmap <leader>e <Plug>(go-run)
au FileType go nmap <leader>r <Plug>(go-coverage)

" if need to save with sudo
cmap w!! w !sudo tee % >/dev/null
nnoremap <leader>bb :CtrlPBuffer<CR>
" close current buffer but leave the window open
nnoremap <leader>bd :bp<bar>sp<bar>bn<bar>bd<CR>
" simply go to the next buffer
nnoremap <leader>bn :bn<CR>
" simply go to the previous buffer
nnoremap <leader>bp :bp<CR>

" simply go to the next buffer
nnoremap <C-b>n :bn<CR>

" display all whitespace chars with set list
set listchars=eol:$,tab:>.,trail:.,extends:\#,nbsp:.

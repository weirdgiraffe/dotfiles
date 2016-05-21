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

" display current line number in yellow
augroup CurrentLineNumberHighlight
  au!
  au! ColorScheme * hi clear CursorLine
  au! ColorScheme * hi CursorLineNR ctermfg=3
augroup END


" load plugins
try
  call plug#begin($HOME.'/.vim/plugged')
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'kien/ctrlp.vim'
  Plug 'klen/python-mode'
  Plug 'scrooloose/nerdtree'
  Plug 'weirdgiraffe/vim-template'
  call plug#end()
catch
  echom "Plug is not installed"
endtry

if (g:loaded_plug)
  let g:loaded_netrw=1                      " disable netrw and use NERDTree
  let g:loaded_netrwPlugin=1                " disable netrw and use NERDTree

  " F2  Display/Hide NERDTree
  nnoremap <F2> :NERDTreeToggle<CR>

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

  set noshowmode                            " dont display modeline because we have airline
  let g:airline_powerline_fonts=1           " enable powerfonts for airline

  let g:airline_theme="solarized"
  let g:solarized_termcolors=254            " force theme to use ansi colors which match gnome terminal
  let g:airline_solarized_bg="dark"
  " Enable the list of buffers in a topline
  let g:airline#extensions#tabline#enabled=1
  " Show just the filename in buffers list
  let g:airline#extensions#tabline#fnamemod=':t'

  let g:pymode=1                            " enable py-mode
  let g:pymode_python='python3'             " use python3 as interpreter
  let g:pymode_indent=1                     " enable pep8 indendation
  let g:pymode_folding=1                    " enable folding
  let g:pymode_rope_complete_on_dot=0       " disable rope completions on .
  let g:pymode_options_max_line_length=79   " line warning on such linelen

  " in vim-templates get user email from gitconfig
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

" remove trailing whitespaces and \^M chars
function! StripTrailingWhitespace()
  " preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business:
  %s/\s\+$//e
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
au FileType py,c,cpp,java,
 \go,php,javascript,puppet,
 \python,rust,twig,xml,yml,
 \perl,sql
 \  autocmd BufWritePre <buffer>
 \  call StripTrailingWhitespace()

" higlight lines in python if they are more than 80 chars
augroup HighlightOverLength
  au!
  au FileType py,python
   \ au BufEnter * hi OverLength ctermbg=1
  au FileType py,python
   \ au BufEnter * match OverLength /.\%>80v/
augroup END


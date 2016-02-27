"try to load plug on fail set fallback_flag
try
  call plug#begin('~/.vim/plugged')
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'klen/python-mode'
  Plug 'aperezdc/vim-template'
  Plug 'scrooloose/nerdtree'

  if executable("ruby")
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  endif

  call plug#end()
  let g:noplugin_fallback=0

  " completely disable netrw in favor of NERDTree
  let g:loaded_netrw=1
  let g:loaded_netrwPlugin=1
catch
  let g:noplugin_fallback=1
endtry

function! StripTrailingWhitespace()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business:
  %s/\s\+$//e
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

set nocompatible
set background=dark
set encoding=utf-8
"enable 256 colors support
let &t_Co=256
"restore screen after quit
if has("terminfo")
  let &t_Sf="\ESC[3%p1%dm"
  let &t_Sb="\ESC[4%p1%dm"
else
  let &t_Sf="\ESC[3%dm"
  let &t_Sb="\ESC[4%dm"
endif

set incsearch
filetype plugin indent on
syntax on
set history=100
set showmatch
set ignorecase                                       "ignore case if search with /,? etc.
set smartcase                                        "case sensitive if uppercase in search pattern
set listchars=eol:$,tab:>.,trail:.,extends:\#,nbsp:. "dispaley all whitespace chars with set list

" remove trailing whitespaces and \^M chars
autocmd FileType py,c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> call StripTrailingWhitespace()

"statusline
set laststatus=2 "always show statusline
if (g:noplugin_fallback)
  set statusline=%-20t%m%r%h%w                                    "left block
  set statusline+=%=
  set statusline+=%y[%{&fenc==\"\"?&enc:&fenc},%{&ff}]\ %-3v:%4l\ "right block
  hi StatusLine ctermbg=15 ctermfg=10
else
  set noshowmode "we dont need modehint anymore: we got airline
  let g:airline_theme="distinguished"
  let g:airline_powerline_fonts = 1
  let ttimeout=50
endif


filetype plugin on
let mapleader=","
syntax enable

" colorscheme 
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized

let g:pymode=1
let g:pymode_python='python3'
let g:pymode_indent=1
let g:pymode_folding=0
let g:pymode_rope_complete_on_dot=0
autocmd FileType python setlocal nonumber "remove line numbers in pythonmode







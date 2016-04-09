" vim:ts=2:sw=2:et
" load plugins
try
  call plug#begin('$HOME/.vim/plugged')

  " plugins for a greate statusline
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  " great plugin for search everywhere
  Plug 'kien/ctrlp.vim'
  " python goodies
  Plug 'klen/python-mode'
  " file browser to replase netrw
  Plug 'scrooloose/nerdtree'

  " questionable plugin to list and swich between
  " buffers. Has key conflicts with python-mode
  Plug 'jeetsukumaran/vim-buffergator'
  " questionable plugin for new file files
  Plug 'weirdgiraffe/vim-template'
  call plug#end()
catch
  echom "Plug is not installed"
endtry
"
" colorscheme
"
let &t_Co=256              " set 256 colors
if has("terminfo")         " restore terminal screen after quit
  let &t_Sf="\ESC[3%p1%dm"
  let &t_Sb="\ESC[4%p1%dm"
else
  let &t_Sf="\ESC[3%dm"
  let &t_Sb="\ESC[4%dm"
endif
syntax enable
set background=dark
let g:solarized_termtrans=1
colorscheme solarized
if (g:loaded_plug) " if have plugins installed

  "
  " NERDTree
  " <F2> show current file in NERDTree (NERDTReeFind)
  " <S-F2> close tree (NERDTReeClose)
  " inside NERDTree:
  "     F3 - Preview
  "     F4 - Edit
  " like in old-good-midnight commander
  "
  let g:loaded_netrw=1
  let g:loaded_netrwPlugin=1
  silent! nnoremap <F2> :NERDTreeToggle<CR>
  let g:NERDTreeMapPreview="<F3>"
  let g:NERDTreeMapActivateNode="<F4>"
  "
  " airline and airline-themes
  "
  set noshowmode "we dont need modehint anymore: we got airline
  let g:airline_powerline_fonts=1
  " force theme to use ansi colors which match gnome terminal
  let g:solarized_termcolors=254 
  let g:airline_solarized_bg="dark"
  let g:airline_theme="solarized"
  "
  " py-mode
  "
  let g:pymode=1                            " enable py-mode
  let g:pymode_python='python3'             " use python3 as interpreter
  let g:pymode_indent=1                     " enable pep8 indendation
  let g:pymode_folding=1                    " enable folding
  let g:pymode_rope_complete_on_dot=0       " disable rope completions on .
" autocmd FileType python setlocal nonumber "remove line numbers in pythonmode
  "
  " vim-template
  "
  " use email from gitconfig in templates
  let g:email=substitute(system('git config --get user.email'), '[\r\n]*$', '', '')

else " if have no plugins

  " set statusline at least
  " left block
  set statusline=%-20t%m%r%h%w
  set statusline+=%=
  " right block
  set statusline+=%y[%{&fenc==\"\"?&enc:&fenc},%{&ff}]\ %-3v:%4l\
  hi StatusLine ctermbg=15 ctermfg=10

endif

if !has('nvim')
  set nocompatible  " I don't need vi compatibility
endif
set laststatus=2    " always show statusline
let ttimeot=50      " reduce timeout between keystrokes

" vim encodings and files encoding
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8            " default encoding displayed by vim
  setglobal fileencoding=utf-8  " change default file encoding when writing new files
endif

set splitright    " in vertical split open new file in the right pane
set ignorecase    " ignore case if search with /,? etc.
set smartcase     " case sensitive if uppercase in search pattern
set incsearch     " highlight search term while typing
set showmatch     " show matching bracets
set history=100   " increase history
let mapleader=',' " remap leader to ,
set foldlevel=20  " do not fold first 20 levels when open a file

"
" enable syntax specific things
"
filetype plugin on
filetype plugin indent on
set listchars=eol:$,tab:>.,trail:.,extends:\#,nbsp:. "dispaley all whitespace chars with set list
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
autocmd FileType py,c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> call StripTrailingWhitespace()
" explisitely define directory to store temp files in cygwin
if has("win32unix")
  silent execute '!mkdir -p "'.$VIMRUNTIME.'/temp"'
  set backupdir=$VIMRUNTIME/temp/
  set directory=$VIMRUNTIME/temp/
  silent execute '!rm -f "'.$VIMRUNTIME.'/temp/*~"'
  silent execute '!rm -f "'.$VIMRUNTIME.'/temp/.*~"'
endif
" close current buffer but leave the window open
nnoremap <C-b>d :bp<bar>sp<bar>bn<bar>bd<CR>
" simply go to the next buffer
nnoremap <C-b>n :bn<CR>














" vim:ts=2:sw=2:et

" remove old compatibility shit
" - disable vi compatibility (help
" - fix backspace functionality (:help 'backspace')
" - disable Ex mode (:help Q, :help gQ)
set nocompatible
set backspace=indent,eol,start
set encoding=utf-8
nnoremap Q <Nop>
nnoremap gQ <Nop>

" .swp, ~, and undo files
" normaly these files are stored in the same folder as file itself
" producing a great mess of hidden files. For me these backups are
" like a session storage, i.e. they could be deleted after a reboot.
" /tmp is almost always mounted as tmpfs, so let's store them there
" NOTE: not windows compatible, but who cares ?!
" NOTE: check (:help dir) for // explanation
silent execute '!mkdir -p "/tmp/vim/$USER/backup"'
silent execute '!mkdir -p "/tmp/vim/$USER/swap"'
silent execute '!mkdir -p "/tmp/vim/$USER/undo"'
set undodir=/tmp/vim/$USER/undo//
set backupdir=/tmp/vim/$USER/backup//
set directory=/tmp/vim/$USER/swap//
set backup
set writebackup
set swapfile
set undofile
autocmd BufWritePre * let &backupext = substitute(expand('%:p:h'), '/', '%', 'g')

" Terminal settings
if has("terminfo")
  set t_Co=256
  set t_Sf="\ESC[3%p1%dm"
  set t_Sb="\ESC[4%p1%dm"
else
  set t_Co=256
  set t_Sf="\ESC[3%dm"
  set t_Sb="\ESC[4%dm"
endif

" useful behaviour tweaks
" - fix undo (http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U)
" - set maximum history length
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
set listchars=eol:$,tab:>.,trail:.,extends:\#,nbsp:.
set history=100           " how many lines of command history to keep
set showcmd               " enable vim built-in command completion
set ignorecase            " ignore case if search with /,? etc.
set smartcase             " case sensitive if uppercase in search pattern
set incsearch             " highlight search term while typing
set showmatch             " show matching bracets
set nohlsearch            " do not highlight all search results
set autoindent            " indent automatically
set splitright            " vertical split focus on the right pane
set splitbelow            " horisontal split focus on the bottom pane
set hidden                " allow switch of modified buffers
set mouse=                " disable mouse in every mode
set foldlevel=20          " do not fold first 20 levels when open a file
set laststatus=2          " always show statusline
set ttimeoutlen=50        " reduce timeout between keystrokes
set cursorline            " highlight cursorline for all files
set synmaxcol=140         " turn off syntax coloring after 140 symbols
let mapleader = ','       " set the leader button

" Color scheme
if empty(glob($HOME.'/.vim/colors/solarized.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/altercation/vim-colors-solarized/master/colors/solarized.vim
  source $MYVIMRS
endif
set background=dark
let g:solarized_termtrans = 1
colorscheme solarized

" Vim-Plug
if empty(glob($HOME.'/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
call plug#begin($HOME.'/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
Plug 'Shougo/neocomplete.vim'
" snipets engine, used by vim-go
Plug 'SirVer/ultisnips'
Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoInstallBinaries'}
if executable("make") && executable("cc") && executable("ld")
  " plugin for asycnchronous process call
  Plug 'Shougo/vimproc.vim', {'do' : 'make'}
endif
if executable("cmake") && !empty(glob('/usr/include/python*'))
  " autocompletion for c/c++/python
  Plug 'Valloric/YouCompleteMe', {'for': 'c,cpp,python'}
  " YCM project generator
  Plug 'rdnetto/YCM-Generator', {'for': 'c,cpp', 'branch': 'stable'}
endif
if executable("pylama")
  " linters and checkers, pylama is a dependency for python
  "   https://github.com/klen/pylama
  Plug 'vim-syntastic/syntastic', {'for': 'python'}
endif
" syntax dependant templates
Plug 'weirdgiraffe/vim-template'
" dependency for gist-vim
Plug 'mattn/webapi-vim'
" plugin to work with github gists
Plug 'mattn/gist-vim'
call plug#end()

" vim-airline {{{
set noshowmode                                   " don't show modeline because of airline
let g:airline_powerline_fonts = 1                " enable powerfonts for airline
let g:airline_theme = "solarized"
let g:airline_solarized_bg = "dark"
let g:airline#extensions#tabline#enabled = 1     " Enable the list of buffers in a topline
let g:airline#extensions#tabline#fnamemod = ':t' " Show filename only in buffer list
" vim-airline }}}

" nerdtree {{{
let g:loaded_netrw = 1                           " disable netrw and use NERDTree instead
let g:loaded_netrwPlugin = 1                     " disable netrw and use NERDTree instead
nnoremap <F2> :NERDTreeToggle<CR>
" F2  Display/Hide NERDTree
let NERDTreeIgnore = ['__pycache__', '\.pyc', '\.o', '\.git', '\.svn']
" F3 Preview file when inside NERDTree
let g:NERDTreeMapPreview = "<F3>"
" nerdtree }}}

" ctrlp.vim {{{
" Filenames and directory names to ignore in ctrlp plugin
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|\.svn|\.ropeproject|\.cache|__pycache__)$',
  \ 'file': '\v(\.exe|\.lib|\.so|\.dll|\.pyc|\~)$',
  \ }
" ctrlp.vim }}}

" vim-template {{{
let g:username = substitute(system('git config --get user.name'), '[\r\n]*$', '', '')
let g:email = substitute(system('git config --get user.email'), '[\r\n]*$', '', '')
" vim-template }}}

" neocomplete.vim {{{
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
   return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
endfunction
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
au FileType css setlocal omnifunc=csscomplete#CompleteCSS
au FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
au FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
au FileType python setlocal omnifunc=pythoncomplete#Complete
au FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
au FileType go setlocal omnifunc=go#complete#Complete
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
" neocomplete.vim }}}

" vim-go {{{
let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 1
let g:go_gocode_unimported_packages = 1
let g:go_template_autocreate = 0
let g:go_auto_type_info = 1
let g:go_addtags_transform = "snakecase"
let g:go_def_reuse_buffer = 1
au FileType go nmap <leader>q <Plug>(go-build)
au FileType go nmap <leader>w <Plug>(go-test)
au FileType go nmap <leader>e <Plug>(go-coverage)
au FileType go nmap <leader>r <Plug>(go-referrers)
au FileType go nmap <leader>t <Plug>(go-def-vertical)
au FileType go nmap <leader>d :GoDecls<CR>
" vim-go }}}

" gist-vim {{{
let g:gist_open_browser_after_post = 1
let g:gist_post_private = 1            " new gists should be private
" gist-vim }}}

" YouCompleteMe {{{
au FileType c,cpp,python nmap gd :YcmCompleter GoTo<CR>
" YouCompleteMe }}}

" custom key mappings
" to write some into some file own by root just type :w!!
cmap w!! w !sudo tee % >/dev/null
" list open buffers
nnoremap <leader>bb :CtrlPBuffer<CR>
" close current buffer but leave the window open
nnoremap <leader>bd :bp<bar>sp<bar>bn<bar>bd<CR>
" simply go to the next buffer
nnoremap <leader>bn :bn<CR>
" simply go to the previous buffer
nnoremap <leader>bp :bp<CR>

" syntax settings. better to have it at the end
" because vim-go could not work if syntax is enabled
" before plugins load.
if !exists("g:syntax_on")
  syntax enable           " enable syntax highlighting
endif
filetype on               " enable filetype detection
filetype plugin on        " enable filetype plugins
filetype plugin indent on " enable syntax defined indendation


" vim:ts=2:sw=2:et

"  disable Ex mode because I never use it ( :help Q, :help gQ )
nnoremap Q <Nop>
nnoremap gQ <Nop>

" enable and configure swap (.swp), backup (~), and undo files
" Normaly these files are stored in the same folder as file itself,
" producing a great mess of hidden files. I handle these backups as
" a session storage, i.e. they could be harmlesly deleted after a
" reboot.
" /tmp is always mounted as tmpfs on all my systems, so let's store
" them there removing on every system start.
" NOTE: not windows compatible, but who cares ?!
" NOTE: check (:help dir) for // explanation
silent execute '!mkdir -p "/tmp/nvim/$USER/backup"'
silent execute '!mkdir -p "/tmp/nvim/$USER/swap"'
silent execute '!mkdir -p "/tmp/nvim/$USER/undo"'
set undodir=/tmp/nvim/$USER/undo//
set backupdir=/tmp/nvim/$USER/backup//
set directory=/tmp/nvim/$USER/swap//
set backup
set writebackup
set swapfile
set undofile
" small hack to get unique names for a backup files stored in external dir
autocmd BufWritePre * let &backupext = substitute(expand('%:p:h'), '/', '%', 'g')

" default value of history in nvim is a huge 10000, and it is stored
" persistent like .viminfo file. I don't like such behaviour, so let's
" store it in a session like fashion, i.e store history file in a /tmp
" folder assuming it will be cleaned up on restart.
" NOTE: check (:help sd, :help shada)
silent execute '!mkdir -p "/tmp/nvim/$USER/"'
set shada=!,'100,<50,s10,h,n/tmp/nvim/$USER/main.shada

" fix undo ( http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U )
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" clipboard is a tricky thing in neovim. I relay completely on tmux,
" which will be discovered by neovim automaticaly, so the clipboard
" is shared between different neovim instances and tmux panes as well
set clipboard=unnamed

set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<,nbsp:%
let &showbreak = '^'

set ignorecase            " ignore case if search with /,? etc.
set smartcase             " case sensitive if uppercase in search pattern
set showmatch             " show matching bracets
set nohlsearch            " do not highlight all search results
set autoindent            " indent automatically
set splitright            " vertical split focus on the right pane
set splitbelow            " horisontal split focus on the bottom pane
set hidden                " allow switch of modified buffers
set mouse=                " disable mouse in every mode
set foldlevel=20          " do not fold first 20 levels when open a file
set guicursor=            " use block cursor shape always
set cursorline            " highlight cursorline for all files
set synmaxcol=160         " turn off syntax coloring after 160 symbols
set scrolloff=20          " min number of lines to keep above/bellow current line
set number                " show line numbers
let mapleader = ','       " set the leader button

" list of files which should be ignored on completion
set wildignore+=.DS_Store
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd
set wildignore+=*.o,*.obj,*.min.js,*.pyc,*/__pycache__/*
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set wildignore+=*.tar,*.gz,*.bz,*.lzma,*.tgz,*.tbz,*.zip,*.rar,*.iso

set wildmode=full,list:full " autocompleting files: full, don't autopick.

" install vim-plug ( https://github.com/junegunn/vim-plug )
if empty(glob($HOME.'/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
   \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  " reload config after installation
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin($HOME.'/.local/share/nvim/plugged')
Plug 'lifepillar/vim-solarized8'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoInstallBinaries'}
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'kien/ctrlp.vim'
Plug 'SirVer/ultisnips'
Plug 'christoomey/vim-tmux-navigator'
call plug#end()

" colors {{{
let g:solarized_use16=1
set background=dark
colorscheme solarized8
" change annoing color of ~ symbols in empty file
hi NonText ctermfg=NONE
" reflect background color change of tmux panes
hi Normal ctermbg=NONE
" make cursorline look better
hi CursorLine cterm=NONE ctermbg=0 gui=NONE
" make numbers look better
hi LineNr ctermbg=NONE
set noshowmode          " don't show modeline because of airline
let g:airline_theme="solarized"
let g:airline_solarized_bg="dark"
let g:airline_powerline_fonts=1                " enable powerfonts for airline
let g:airline#extensions#tabline#enabled=1     " Enable the list of buffers in a topline
let g:airline#extensions#tabline#fnamemod=':t' " Show filename only in buffer list
let g:airline#extensions#tabline#keymap_ignored_filetypes=['nerdtree']
let g:airline#extensions#tabline#buffer_idx_mode=1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab
" colors }}}

" vim-tmux-navigator {{
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
" vim-tmux-navigator }}

" nerdtree {{{
let g:loaded_netrw = 1            " disable netrw and use NERDTree instead
let g:loaded_netrwPlugin = 1      " disable netrw and use NERDTree instead
" F2  Display/Hide NERDTree
nnoremap <F2> :NERDTreeToggle<CR>
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

" deocomplete {{
let g:deoplete#enable_at_startup = 1
" deocomplete }}

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
au FileType go nmap <leader>i :GoImplements<CR>
au FileType go nmap <leader>t <Plug>(go-def-vertical)
au FileType go nmap <leader>d :GoDecls<CR>
" vim-go }}}

" custom key mappings
" to write some into some file own by root just type :w!!
cmap w!! w !sudo tee % >/dev/null
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

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
set synmaxcol=160         " turn off syntax coloring after 160 symbols
set scrolloff=20          " min number of lines to keep above/bellow current line
set norelativenumber      " do not show relative line numbers
set rnu                   " show relative line numbers
set noshowmode            " don't show modeline because of airline
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


" colors support {{
"
" 24 bit colors support. More details:
"   - https://vimhelp.org/term.txt.html
"   - https://github.com/rakr/vim-one#true-color-support
if (has("nvim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
"
" colors support }}
"




call plug#begin($HOME.'/.local/share/nvim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'christoomey/vim-tmux-navigator'
Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoInstallBinaries'}
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'SirVer/ultisnips'
Plug 'iamcco/markdown-preview.vim'
Plug 'uarun/vim-protobuf'
Plug 'airblade/vim-gitgutter'
Plug 'tomlion/vim-solidity'

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
" Plug 'kien/ctrlp.vim'

" themes {{{
Plug 'vim-airline/vim-airline-themes'
" Plug 'rakr/vim-one'
Plug 'reedes/vim-colors-pencil'
Plug 'kyoz/purify', { 'rtp': 'vim' }
" themes }}}

call plug#end()

" nerdtree {{{
let g:loaded_netrw = 1            " disable netrw and use NERDTree instead
let g:loaded_netrwPlugin = 1      " disable netrw and use NERDTree instead
let NERDTreeIgnore = ['__pycache__', '\.pyc', '\.o', '\.git', '\.svn']
" nerdtree }}}

" airline {{{
let g:airline_powerline_fonts=1                " enable powerfonts for airline
let g:airline#extensions#tabline#enabled=1     " Enable the list of buffers in a topline
let g:airline#extensions#tabline#fnamemod=':t' " Show filename only in buffer list
let g:airline#extensions#tabline#keymap_ignored_filetypes=['nerdtree']
let g:airline#extensions#tabline#buffer_idx_mode=1
let g:airline#extensions#default#section_truncate_width = {
      \ 'b': 79,
      \ 'x': 60,
      \ 'y': 88,
      \ 'z': 45,
      \ 'warning': 80,
      \ 'error': 80,
      \ }
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
" airline }}}

" vim-tmux-navigator {{
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
nnoremap <silent> <M-l> :TmuxNavigateRight<cr>

" vim-tmux-navigator }}


" vim-go {{{
let g:go_metalinter_command='golangci-lint'
let g:go_metalinter_enabled=[
  \ 'revive',
  \ 'deadcode',
  \ 'errcheck',
  \ 'gosimple',
  \ 'govet',
  \ 'staticcheck',
  \ 'typecheck',
  \ 'unused',
  \ 'varcheck'
  \ ]
let g:go_metalinter_deadline = "30s"
let g:go_jump_to_error = 0
let g:go_metalinter_autosave = 1
let g:go_metalinter_autosave_enabled = ['vet']

" let g:go_gopls_enabled = 1
let g:go_gopls_complete_unimported = 1
let g:go_gopls_deep_completion = 1
let g:go_gopls_fuzzy_matching = 1
let g:go_gopls_staticcheck = 1
let g:go_gopls_use_placeholders = 0

let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 1
let g:go_info_mode = 'gopls'
let g:go_def_mode = 'gopls'
let g:go_referers_mode = 'gopls'
let g:go_implements_mode = 'gopls'
let g:go_rename_command = 'gopls'

let g:go_term_close_on_exit = 1
let g:go_code_completion_enabled = 1
" let g:go_debug = ['lsp']

let g:go_template_autocreate = 0
" let g:go_addtags_transform = 'camelcase'
let g:go_addtags_transform = 'snakecase'
let g:go_test_timeout = '60s'
au FileType go nmap <leader>a :GoAlternate<CR>
au FileType go nmap <leader>r <Plug>(go-referrers)
au FileType go nmap <leader>i :GoImplements<CR>
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>tf <Plug>(go-test-func)
au FileType go nmap <leader>tc <Plug>(go-coverage)
au FileType go nmap <leader>l  <Plug>(go-metalinter)
au FileType go nmap <leader>d :GoDecls<CR>

" vim-go }}}




" deoplete {{
set completeopt+=noinsert
set completeopt+=noselect
set completeopt-=preview
if has("patch-7.4.314")
  set shortmess+=c
endif


let g:python3_host_prog = "/opt/homebrew/bin/python3"
let g:python3_host_skip_check = 1
" if executable("python3")
"   let g:python3_host_prog = exepath("python3")
"   let g:python3_host_skip_check = 1
" endif

let g:deoplete#enable_at_startup = 1
let g:deoplete#complete_method = "omnifunc"
" call deoplete#custom#option('profile', v:true)
" call deoplete#enable_logging('DEBUG', 'deoplete.log')
call deoplete#custom#option({
\ 'auto_complete': v:true,
\ 'auto_complete_delay': 0,
\ 'auto_refresh_delay': 10,
\ 'refresh_always': v:false,
\ 'num_processes': 8,
\ 'smart_case': v:true,
\ 'omni_patterns': {'go':'[^. *\t]\.\w*'},
\ })

call deoplete#custom#source('ultisnips', 'rank', 1)
let g:deoplete#sources#go#sort_class = ['func', 'var', 'const', 'type', 'package']
let g:deoplete#sources#go#auto_goos = 1
let g:deoplete#sources#go#source_importer = 1
" deoplete }}

" fzf.vim {{{

" Empty value to disable preview window altogether
let g:fzf_preview_window = ['right', 'ctrl-/']
let g:fzf_layout = {'down': '40%'}
let g:fzf_buffers_jump = 1

function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' s:find_git_root()

nmap <C-P> :ProjectFiles<CR>
nmap <C-I> :Buffers<CR>

" fzf.vim }}}


" ctrlp.vim {{{

" Filenames and directory names to ignore in ctrlp plugin
" let g:ctrlp_custom_ignore = {
"   \ 'dir':  '\v[\/](\.git|node_modules|\.svn|\.ropeproject|\.cache|__pycache__|vendor)$',
"   \ 'file': '\v(\.exe|\.lib|\.so|\.dll|\.pyc|\~)$',
"   \ }

" Use fd for ctrlp.
" if executable('fd')
"     let g:ctrlp_user_command = 'fd --type f --color never "" %s'
"     let g:ctrlp_use_caching = 0
" endif

" nmap <C-I> :<C-U>CtrlPBuffer<CR>

" ctrlp.vim }}}



" vim-gitgutter {{{
" let g:gitgutter_grep='grep --color=never'
" vim-gitgutter }}}

" custom key mappings
" to write some into some file own by root just type :w!!
cmap w!! w !sudo tee % >/dev/null
" close current buffer but leave the window open
nnoremap <leader>bd :bp<bar>sp<bar>bn<bar>bd<CR>
" simply go to the next buffer
nnoremap <leader>bn :bn<CR>
" simply go to the previous buffer
nnoremap <leader>bp :bp<CR>



" better to have syntax settings at the end because, for example vim-go could
" not work if syntax is enabled before plugin is loaded
syntax enable
filetype plugin indent on

set foldmethod=syntax

fun! _close_all_but_current_buffer()
  let curr = bufnr("%")
  let last = bufnr("$")

  if curr > 1    | silent! execute "1,".(curr-1)."bd"     | endif
  if curr < last | silent! execute (curr+1).",".last."bd" | endif
endfun


nnoremap <leader>bq :call _close_all_but_current_buffer()<CR>
nnoremap <leader>id "=strftime("%x %X (%Z)")<CR>P


" colors {{{

" colorscheme one
" let g:airline_theme='one'
" set background=light

" colorscheme pencil
" let g:pencil_higher_contrast_ui = 0   " 0=low (def), 1=high
" let g:pencil_neutral_code_bg = 1      " 0=gray (def), 1=normal
" let g:pencil_gutter_color = 1         " 0=mono (def), 1=color
" let g:pencil_terminal_italics = 1
" let g:airline_theme = 'pencil'
" set background=light
" set cursorline
" augroup BgHighlight
"     autocmd!
"     autocmd FocusGained * setlocal cursorline
"     autocmd FocusLost   * setlocal nocursorline
" augroup END

colorscheme purify
let g:airline_theme='purify'


set synmaxcol=130
augroup _go_long_lines
  au!
  "au BufEnter,BufWinEnter *.go highlight OverLength guibg=black guifg=orange
  au BufEnter,BufWinEnter *.go hi OverLength guibg=red guifg=white
  "au BufEnter,BufWinEnter *.go match OverLength /\%130v.*/
  au BufEnter,BufWinEnter *.go match OverLength /\%131v[^`]*$/
  au BufLeave,BufWinLeave *.go call clearmatches()
augroup END


hi Normal guibg=terminal guifg=terminal
"hi SpellBad guibg=none

" colors }}}

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin(

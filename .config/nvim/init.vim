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

" list of files which should be ignored on completion
set wildignore+=.DS_Store
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd
set wildignore+=*.o,*.obj,*.min.js,*.pyc,*/__pycache__/*
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set wildignore+=*.tar,*.gz,*.bz,*.lzma,*.tgz,*.tbz,*.zip,*.rar,*.iso

set wildmode=full,list:full " autocompleting files: full, don't autopick.

" install vim-plug ( https://github.com/junegunn/vim-plug )
if empty(glob($HOME.'/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim
   \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif



"try to load plug on fail set fallback_flag
try
  call plug#begin('~/.vim/plugged')
  Plug 'vim-airline/vim-airline'
  Plug 'tpope/vim-fugitive'
  
  if executable("ruby") 
    Plug 'junegunn/fzf'
  endif

  call plug#end()
  let g:noplugin_fallback=0
catch
  let g:noplugin_fallback=1
endtry

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

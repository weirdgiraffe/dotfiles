setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab

" this settings are for solarized colorscheme
" check https://github.com/altercation/vim-colors-solarized

" set overflow background to base01
" set overflow foreground to base03
hi PythonOverflowSymbols ctermbg=10
hi PythonOverflowSymbols ctermfg=8

" to show which lines with length more than 80 symbols,
" let's define some highlighting
fun! PythonUpdateLineOverflow()
  if &ft =~ '^\%(py\|python\)$'
    match PythonOverflowSymbols /\%81v.*/
  else
    match NONE
  endif
endfun

" update lines when enter is pressed
autocmd BufEnter,BufWinEnter *
  \ call PythonUpdateLineOverflow()

" remove all trailing whitespaces on :w
autocmd FileType py,python
  \ autocmd BufWritePre <buffer>
  \  %s/\s\+$//e


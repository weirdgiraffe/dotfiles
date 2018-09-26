setlocal nonumber
setlocal ts=4
setlocal sw=4
setlocal et
let b:indent_already_set=1

" Wrap line at 80 symbols (79 + '\n'). But this line doesn't guarantee the
" proper line length. If you edit one of the autoformated lines, your line
" length changes and will not be autowrapped. And that is good, because
" otherwise you could loose your original formating
setlocal tw=79

" this settings are for solarized colorscheme
" check https://github.com/altercation/vim-colors-solarized
" set overflow background to base02
hi MarkdownOverflowSymbols ctermbg=9 ctermfg=8

" highlighting for lines with length more than 80 symbols
fun! MarkdownUpdateLineOverflow()
  if  &ft == 'markdown'
    " do not highlite overflow on markdown tables
    match MarkdownOverflowSymbols /\%81v\(.*[^|]\)$/
  else
    match NONE
  endif
endfun

" update lines when enter is pressed
autocmd BufEnter,BufWinEnter *
  \ call MarkdownUpdateLineOverflow()

" update lines when enter is pressed
autocmd BufEnter,BufWinEnter *
  \ call MarkdownUpdateLineOverflow()

" remove all trailing whitespaces in markdown on :w
autocmd Syntax markdown
  \ autocmd BufWritePre <buffer>
  \  %s/\s\+$//e

" now default markdown.vim will be executed and it will set settings from
" html, including ts and sw

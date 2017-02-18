" Vim filetype plugin
" Language:		Markdown
" Maintainer:		Tim Pope <vimNOSPAM@tpope.org>
" Last Change:		2013 May 30

if exists("b:did_ftplugin")
  finish
endif

runtime! ftplugin/html.vim ftplugin/html_*.vim ftplugin/html/*.vim

setlocal comments=fb:*,fb:-,fb:+,n:> commentstring=>\ %s
setlocal formatoptions+=tcqln formatoptions-=r formatoptions-=o
setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^[-*+]\\s\\+

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= "|setl cms< com< fo< flp<"
else
  let b:undo_ftplugin = "setl cms< com< fo< flp<"
endif

setlocal ts=4
setlocal sw=4
setlocal et

" Wrap line at 80 symbols (79 + '\n'). But this line doesn't guarantee the
" proper line length. If you edit one of the autoformated lines, your line
" length changes and will not be autowrapped. And that is good, because
" otherwise you could loose your original formating
setlocal tw=79

" to show which lines with length more than 80 symbols, let's define some
" highlighting
fun! MarkdownUpdateLineOverflow()
  match MarkdownOverflowSymbols /\%80v.*/
endfun

" this settings are for solarized colorscheme
" check https://github.com/altercation/vim-colors-solarized

" set overflow background to base01
" set overflow foreground to base03
hi MarkdownOverflowSymbols ctermbg=10
hi MarkdownOverflowSymbols ctermfg=8

" update lines when enter is pressed
autocmd Syntax markdown
  \ autocmd BufEnter,BufWinEnter *
  \  call MarkdownUpdateLineOverflow()


" remove all trailing whitespaces in markdown on :w
autocmd Syntax markdown
  \ autocmd BufWritePre <buffer>
  \  %s/\s\+$//e


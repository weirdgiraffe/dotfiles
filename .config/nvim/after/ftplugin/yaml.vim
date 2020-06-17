setlocal sw=2
setlocal ts=2
setlocal et

autocmd BufWritePre * :%s/\s\+$//e

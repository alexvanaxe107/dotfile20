" Spacing
setlocal sw=2
setlocal ts=2
setlocal sts=2
setlocal expandtab

setlocal colorcolumn=79
setlocal ruler
" Numbers
setlocal number
setlocal relativenumber

"set UTF-8 encoding
setlocal enc=utf-8
setlocal fenc=utf-8
setlocal termencoding=utf-8

" Indentation
filetype indent on
setlocal autoindent " use indentation of previous line
setlocal smartindent " use intelligent indentation for programming

setlocal formatprg=js-beautify\ --type\ html

" highlight matching braces
setlocal showmatch
"hi Normal ctermbg=None

setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=79
setlocal expandtab
setlocal autoindent
setlocal fileformat=unix

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

" Enable syntax
syntax on
syntax enable

" highlight matching braces
setlocal showmatch

" ###### Plugins configs ######
" Jedi
let g:jedi#popup_on_dot = 0

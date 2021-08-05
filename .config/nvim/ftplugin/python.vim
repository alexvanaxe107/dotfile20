setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=79
setlocal expandtab
setlocal autoindent
setlocal fileformat=unix

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

" highlight matching braces
setlocal showmatch

" ###### Plugins configs ######
" Jedi
let g:jedi#popup_on_dot = 0
let g:ale_linters = {'python': ['flake8',]}
let g:ale_echo_msg_format = '%linter% says %s'
"hi Normal ctermbg=None

" Spacing
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
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

" Set formatter
setlocal formatprg=prettier\ --parser\ typescript

nmap <leader>o :TsuImport<CR>

" ##### Plugins ######
" Vim typescript
let g:typescript_indent_disable = 1
" Tsu...
let g:tsuquyomi_single_quote_import= 1
let tsuquyomi_single_quote_import=1
"hi Normal ctermbg=None

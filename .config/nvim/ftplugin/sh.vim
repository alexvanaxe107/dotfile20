filetype indent on

setlocal ruler         " show the cursor position all the time
setlocal sw=4
setlocal ts=4
setlocal sts=4
setlocal expandtab

setlocal textwidth=100
setlocal colorcolumn=+1

setlocal fo-=t

" Numbers
setlocal number
setlocal relativenumber
" set numberwidth=5

" filetype plugin indent on
"set UTF-8 encoding
setlocal enc=utf-8
setlocal fenc=utf-8
setlocal termencoding=utf-8

" use indentation of previous line
" setlocal autoindent
" use intelligent indentation for programming
setlocal smartindent

" turn syntax highlighting on
" set t_Co=256 " Comentado para testar em uma maquina decente
syntax on
syntax enable

" highlight matching braces
setlocal showmatch

" Deoplete -----------------------------

" Comments
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Add your own custom formats or override the defaults
" let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/'  }  }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1


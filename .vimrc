" Mapeamento de teclas    
"
"let $NVIM_TUI_ENABLE_CURSOR_SHAPE=0
    
source ~/.vim/configs/config.vim
source ~/.vim/configs/mappings.vim
source ~/.vim/configs/plugin_minimal.vim

let g:airline_theme="base16_grayscale"


"set guicursor=
" Workaround some broken plugins which set guicursor indiscriminately.
"autocmd OptionSet guicursor noautocmd set guicursor=
    
filetype on 

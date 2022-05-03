" Mapeamento de teclas    
"
"let $NVIM_TUI_ENABLE_CURSOR_SHAPE=0

source ~/.vim/configs/plugin.vim
source ~/.vim/configs/config.vim
source ~/.vim/configs/mappings.vim
source ~/.vim/configs/theme.vim
source ~/.vim/configs/lsp.vim

source ~/.config/nvim/nvim_configs.vim

"set guicursor=
" Workaround some broken plugins which set guicursor indiscriminately.
"autocmd OptionSet guicursor noautocmd set guicursor=
    
filetype on 

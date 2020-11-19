call plug#begin('~/.vim/plugged_minimal')
" #### Helpers
Plug 'gantheory/vim-easymotion'
Plug 'tpope/vim-speeddating'
Plug 'junegunn/goyo.vim'

" #### IDE
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'reedes/vim-pencil', { 'for': ['text', 'notes', 'markdown', 'mkd'] }
Plug 'junegunn/limelight.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ervandew/supertab'


call plug#end()

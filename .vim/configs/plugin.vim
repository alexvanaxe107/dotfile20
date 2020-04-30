call plug#begin('~/.vim/plugged')
" #### Helpers
Plug 'gantheory/vim-easymotion'
Plug 'tpope/vim-speeddating'
Plug 'arielrossanigo/dir-configs-override.vim'
Plug 'junegunn/goyo.vim'

" #### IDE
Plug 'majutsushi/tagbar'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'janko-m/vim-test'
Plug 'tpope/vim-dispatch'
Plug 'scrooloose/nerdcommenter', {'for': ['python', 'html', 'typescript', 'sh']}
Plug 'Yggdroot/indentLine' " Ident guides
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'sk1418/QFGrep'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-surround'
Plug 'ervandew/supertab'
Plug 'dense-analysis/ale' " Linting
Plug 'prettier/vim-prettier' " Formatting

" Javascript/Typescript
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'Quramy/tsuquyomi'

" html
Plug 'mattn/emmet-vim' " Generate code html

" Python
Plug 'davidhalter/jedi-vim'

" #### EYECANDY
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'NLKNguyen/papercolor-theme'
Plug 'mkitt/tabline.vim'

call plug#end()
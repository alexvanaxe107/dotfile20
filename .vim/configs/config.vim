filetype on
filetype plugin on
syntax on

" Set the encoding
set encoding=utf-8

set undofile " Maintain undo history between sessions not so eternally!
set undodir=$HOME/.vim/history

" disable vi compatibility (emulation of old bugs)
set nocompatible
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set showcmd       " display incomplete commands
" highlight matching braces
set showmatch
" set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
" set autowrite     " Automatically :write before running commands

set spell spelllang=en_us
" set complete+=k
set spell!
"
" fix problems with uncommon shells (fish, xonsh) and plugins running commands
" (neomake, ...)
set shell=/bin/fish
set timeout!
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

let g:airline_powerline_fonts = 1

" Hide de guy menus
set guioptions -=m
set guioptions -=T


let g:indentLine_char = '.'

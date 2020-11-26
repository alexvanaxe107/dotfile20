filetype on
filetype plugin on
syntax on

" Fix tmux background
if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
endif
" Set the encoding
set encoding=utf-8
set wildmenu

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

" Airline Configs
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'

let g:tmuxline_powerline_separators = 0

" Hide de guy menus
set guioptions -=m
set guioptions -=T

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

let g:indentLine_char = '.'

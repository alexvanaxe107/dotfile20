filetype on

filetype plugin on
syntax on

set backspace=indent,eol,start " Testing some configs

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
set undodir=$HOME/.config/.nvim/history
set number
set relativenumber
set signcolumn=yes

set cursorline

" disable vi compatibility (emulation of old bugs)
set nocompatible
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set showcmd       " display incomplete commands
" highlight matching braces
set showmatch
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
" set autowrite     " Automatically :write before running commands

set spell spelllang=en_us
" set complete+=k
set spell!
"
" fix problems with uncommon shells (fish, xonsh) and plugins running commands
" (neomake, ...)
set shell=/bin/zsh
set timeout!
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

let g:python3_host_prog = '/home/alexvanaxe/.pyenv/versions/3.9.7/bin/python'

" Hide de guy menus
"set guioptions -=m
"set guioptions -=T

"set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF

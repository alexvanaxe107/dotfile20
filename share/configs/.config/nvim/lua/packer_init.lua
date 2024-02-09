-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    ---------------------------------------------------
    -- GENERAL
    ---------------------------------------------------
    use {
      'nvim-telescope/telescope.nvim', -- tag = '0.1.0',
    -- or                            , branch = '0.1.x',
      requires = { 'nvim-lua/plenary.nvim' }
    }

    -- fzf
	use {'junegunn/fzf', dir = '~/.fzf', run = './install --all' }
	use {'junegunn/fzf.vim'}

	-- skim
	-- use {'lotabout/skim', dir = '~/.skim', run = './install' }
	-- use 'lotabout/skim.vim'
    

	-- GoYo
	use 'junegunn/goyo.vim'

    -- Using the native fzf, so we can increase performance
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
    -- Navigate with tmux
    use 'christoomey/vim-tmux-navigator'


    ---------------------------------------------------
    -- NAVIGATION
    ---------------------------------------------------
    use 'easymotion/vim-easymotion'

    ---------------------------------------------------
    -- UTILITIES
    ---------------------------------------------------
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-fugitive'

    ---------------------------------------------------
    -- PROGRAMMING
    ---------------------------------------------------
    -- Configurations for Nvim LSP
    use 'neovim/nvim-lspconfig' 

    -- Autocomplete
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'L3MON4D3/LuaSnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'saadparwaiz1/cmp_luasnip',
            'quangnguyen30192/cmp-nvim-ultisnips'
        },
    }

    use 'lukas-reineke/indent-blankline.nvim'
    use {'SirVer/ultisnips',
        requires = {
            -- Snippets are separated from the engine. Add this if you want them:
            'honza/vim-snippets'
        },
    }
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
        requires = {
            'p00f/nvim-ts-rainbow'
        }
    }

      -- Autopair
      use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

    use 'mattn/emmet-vim'

    use 'vim-test/vim-test'

    use {'scrooloose/nerdcommenter', 
     ft = {'python', 'html', 'typescript', 'sh'}}

    use {'bhurlow/vim-parinfer'}

    ---------------------------------------------------
    -- EYECANDY
    ---------------------------------------------------
    -- Colorschemes
    use {'dracula/vim', as = 'dracula'}
    -- Plug 'morhetz/gruvbox'
    use 'Dave-Elec/gruvbox'
    use 'NLKNguyen/papercolor-theme'
    use 'endel/vim-github-colorscheme'
    use 'jaredgorski/fogbell.vim'
    use 'tyrannicaltoucan/vim-deep-space'
    use 'lifepillar/vim-solarized8'
    use 'chriskempson/base16-vim'
    use 'fenetikm/falcon'
    use 'TroyFletcher/vim-colors-synthwave'
    -- use 'kaicataldo/material.vim', { 'branch': 'main' }
    use 'DaikyXendo/nvim-material-icon'
    use 'fneu/breezy'
    use 'whatyouhide/vim-gotham'
    use 'arcticicestudio/nord-vim'
    use 'Ardakilic/vim-tomorrow-night-theme'
    use 'danilo-augusto/vim-afterglow'
    use 'ayu-theme/ayu-vim'
    use 'Arkham/vim-tango'
    use 'effkay/argonaut.vim'
    use 'artanikin/vim-synthwave84'
    use 'sainnhe/gruvbox-material'
    use 'atelierbram/vim-colors_atelier-schemes'
    use 'fxn/vim-monochrome'
    use 'mhartington/oceanic-next'
    use 'andreasvc/vim-256noir'
    use 'wadackel/vim-dogrun'
    use 'arzg/vim-corvine'
    use 'zanglg/nova.vim'
    use 'folke/tokyonight.nvim'
    use 'reedes/vim-colors-pencil'
    --use 'sonph/onehalf', { 'rtp': 'vim' }
    use 'jnurmine/Zenburn'
    use { 'AlphaTechnolog/pywal.nvim', as = 'wal' }
    -- If you are using Packer
    use 'marko-cerovac/material.nvim'
    use 'drewtempelmeyer/palenight.vim'
    use { 'Shadorain/shadotheme' }

    use {
	"catppuccin/nvim",
        as = "catppuccin"
}

    -- Icons
    use 'kyazdani42/nvim-web-devicons'

    -- TopBar
  --  use {'romgrk/barbar.nvim', wants = 'nvim-web-devicons'}

    -- Statusline
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    -- use 'vim-airline/vim-airline'
    -- use 'vim-airline/vim-airline-themes'

    -- use some transparency
    use 'xiyaowong/nvim-transparent'
end)



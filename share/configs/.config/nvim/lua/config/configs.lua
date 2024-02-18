-----------------------------------------------------------
-- General Neovim settings and configuration
-----------------------------------------------------------

-- Default options are not included
-- See: https://neovim.io/doc/user/vim_diff.html
-- [2] Defaults - *nvim-defaults*

local g = vim.g       -- Global variables
local opt = vim.opt   -- Set options (global/buffer/windows-scoped)

opt.clipboard = 'unnamedplus'         -- Copy/paste to system clipboard
--opt.backspace = 'indent, eol, start'

opt.undofile = true  -- Maintain undo history between sessions not so eternally!
opt.undodir = '/home/alexvanaxe/.config/.nvim/history/'


-- UI stuffs
opt.number = true
opt.relativenumber = true
opt.cursorline = false
opt.showcmd = true
opt.showmatch = true        -- Highlight matching parenthesis
opt.showcmd = true -- Display incomplete commands
opt.laststatus=3            -- Set global statusline
-- opt.termguicolors = true    -- Enable 24-bit RGB colors
opt.linebreak = true        -- Wrap on word boundary TESTING
opt.showmatch = true        -- Highlight matching parenthesis
opt.ignorecase = true       -- Ignore case letters when search
opt.smartcase = true        -- Ignore lowercase for the whole pattern
-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true        -- Use spaces instead of tabs
opt.shiftwidth = 4          -- Shift 4 spaces when tab
opt.tabstop = 4             -- 1 tab == 4 spaces
opt.smartindent = true      -- Autoindent new lines

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true           -- Enable background buffers
opt.history = 100           -- Remember N lines in history
opt.lazyredraw = true       -- Faster scrolling
opt.synmaxcol = 240         -- Max column for syntax highlight
opt.updatetime = 700        -- ms to wait for trigger an event

-- Other stuffs
opt.timeout = false
opt.listchars="eol:$,tab:>-,trail:~,extends:>,precedes:<"

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
-- Disable nvim intro
opt.shortmess:append "sI"


-----------------------------------------------------------
-- Plugins configs
-----------------------------------------------------------
-- CMP stuffs
opt.completeopt="menu,menuone,noselect"

-- Test configs
g['test#strategy'] = "make"

-- Enable powerline
g.airline_powerline_fonts = true

require('lualine').setup()

-- require("transparent").setup({
--   extra_groups = { -- table/string: additional groups that should be cleared
--     -- In particular, when you set it to 'all', that means all available groups
-- 
--     -- example of akinsho/nvim-bufferline.lua
--     "BufferLineTabClose",
--     "BufferlineBufferSelected",
--     "BufferLineFill",
--     "BufferLineBackground",
--     "BufferLineSeparator",
--     "BufferLineIndicatorSelected",
--   },
--   exclude_groups = {}, -- table: groups you don't want to clear
-- })

require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}

-- -- Disable builtin plugins
local disabled_built_ins = {
   "2html_plugin",
   "getscript",
   "getscriptPlugin",
   "gzip",
   "logipat",
   "matchit",
   "tar",
   "tarPlugin",
   "rrhelper",
   "spellfile_plugin",
   "vimball",
   "vimballPlugin",
   "zip",
   "zipPlugin",
   "tutor",
   "rplugin",
   "synmenu",
   "optwin",
   "compiler",
   "bugreport",
   "ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
   g["loaded_" .. plugin] = 1
end

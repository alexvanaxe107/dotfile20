-- set completeopt=menu,menuone,noselect
vim.opt.completeopt=menu,menuone,noselect

  -- Setup nvim-cmp.
  local cmp = require'cmp'

   cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    mapping = {
      ['<C-k>'] = cmp.mapping.select_prev_item(),
      ['<C-j>'] = cmp.mapping.select_next_item(),
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = false,
    update_in_insert = false,
    severity_sort = false,
  })

  function PrintDiagnostics(opts, bufnr, line_nr, client_id)
	  bufnr = bufnr or 0
	  line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
	  opts = opts or {['lnum'] = line_nr}

	  local line_diagnostics = vim.diagnostic.get(bufnr, opts)
	  if vim.tbl_isempty(line_diagnostics) then return end

	  local diagnostic_message = ""
	  for i, diagnostic in ipairs(line_diagnostics) do
	    diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
	    print(diagnostic_message)
	    if i ~= #line_diagnostics then
	      diagnostic_message = diagnostic_message .. "\n"
	    end
	  end
	  vim.api.nvim_echo({{diagnostic_message, "Normal"}}, false, {})
end

vim.o.updatetime = 250
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

  local signs = { Error = "", Warn = "", Hint = "", Info = "" }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end


-- Start the lsp configs
on_attach = require('config/lsp_config')

-- Activate the bash setup
require('lspconfig')
require('lspconfig')['bashls'].setup{on_attach=on_attach}

-- Enable HTML
require'lspconfig'.html.setup{on_attach=on_attach}

-- Activate the python setup
require'lspconfig'.pyright.setup{on_attach=on_attach}

-- Activate the angular setup
require('lspconfig')['angularls'].setup{on_attach=on_attach}

-- Activate the vue setup
require'lspconfig'.volar.setup{
	on_attach=on_attach;
	filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'};
}

-- Activate the svelte config
require'lspconfig'.svelte.setup{}

--  Activate the typescript config
require'lspconfig'.tsserver.setup{on_attach=on_attach}

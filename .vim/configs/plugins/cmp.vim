Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

let g:cmpenabled="true"

function TCompletion()
	if g:cmpenabled == "false"
		let g:cmpenabled="true"
		lua require('cmp').setup.buffer { enabled = true }
	else
		let g:cmpenabled="false"
		lua require('cmp').setup.buffer { enabled = false }
	endif
endfunction

nmap <F9> :call TCompletion()<CR>

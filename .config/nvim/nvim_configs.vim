
function DesActivatePopUp()
	call deoplete#custom#option({
	\ 'auto_complete_popup': 'manual',
	\ })
endfunction

function ActivatePopUp()
	call deoplete#custom#option({
	\ 'auto_complete_popup': 'auto',
	\ })
endfunction

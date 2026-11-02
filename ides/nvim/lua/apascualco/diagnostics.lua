vim.diagnostic.config({
	virtual_text = false,
	severity_sort = true,
	float = {
		border = 'rounded',
		source = true,
		focusable = false,
	},
	jump = {
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({ bufnr = bufnr, scope = 'cursor', focus = false })
		end,
	},
})

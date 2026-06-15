-- Diagnostics config.
-- virtual_text is OFF because tiny-inline-diagnostic.nvim renders the under-cursor
-- diagnostic inline (always-on). The rounded float is kept for manual opens
-- (<leader>le, gl) and for the float shown on ]d / [d jumps.
-- (The old CursorHold auto-float was removed: it double-rendered with tiny-inline.
--  Toggle the inline diagnostic with <leader>td.)
vim.diagnostic.config({
	virtual_text = false,
	severity_sort = true,
	float = {
		border = 'rounded',
		source = true,
		focusable = false,
	},
})

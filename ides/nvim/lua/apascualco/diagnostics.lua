-- ========= Auto diagnostic float on CursorHold =========
-- Ajusta el tiempo que esperas sin mover el cursor
vim.o.updatetime = 300

-- Opcional: configuración global de diagnóstico
vim.diagnostic.config({
	virtual_text = false,               -- ya lo usabas
	severity_sort = true,
	float = {
		border = 'rounded',
		source = 'always',
		focusable = false,                -- no roba foco
	},
})

local function show_diagnostic_float(opts)
	opts = opts or {}
	-- Evita popups en buffers/panels especiales
	local ft = vim.bo.filetype
	local skip = {
		NvimTree = true, TelescopePrompt = true, Trouble = true,
		["lazy"] = true, ["neo-tree"] = true,
	}
	if skip[ft] then return end

	-- Comprueba si hay diags bajo el cursor
	local diags = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
	if #diags == 0 then return end

	-- Abre el float
	vim.diagnostic.open_float(nil, vim.tbl_deep_extend("force", {
		scope = "cursor",
		focus = false,
		close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave" },
	}, opts))
end

-- AutoCmd: abre el float al quedarte quieto
local aug = vim.api.nvim_create_augroup("DiagFloatOnHold", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, {
	group = aug,
	callback = function() show_diagnostic_float() end,
})

-- (Opcional) También en insert si te interesa (a veces es molesto):
-- vim.api.nvim_create_autocmd({ "CursorHoldI" }, {
--   group = aug,
--   callback = function() show_diagnostic_float() end,
-- })

-- (Opcional) Toggle rápido por si quieres desactivarlo temporalmente
-- Keybinding movido a keybinding.lua
vim.g._diag_toggle_func = function()
	local enabled = vim.g._diag_float_enabled
	if enabled == nil then enabled = true end
	enabled = not enabled
	vim.g._diag_float_enabled = enabled
	if enabled then
		vim.api.nvim_create_autocmd({ "CursorHold" }, {
			group = aug,
			callback = function() show_diagnostic_float() end,
		})
		vim.notify("Auto diagnostic popup: ENABLED")
	else
		vim.api.nvim_clear_autocmds({ group = aug })
		vim.notify("Auto diagnostic popup: DISABLED")
	end
end
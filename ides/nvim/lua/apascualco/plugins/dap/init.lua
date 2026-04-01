local dap = require("dap")

-- Usar toggleterm para mostrar stdout del proceso con integratedTerminal
dap.defaults.fallback.terminal_win_cmd = function()
  local Terminal = require('toggleterm.terminal').Terminal
  local t = Terminal:new({ direction = 'horizontal', close_on_exit = false })
  t:open()
  vim.api.nvim_set_current_win(vim.fn.bufwinid(t.bufnr))
  return t.bufnr, vim.fn.bufwinid(t.bufnr)
end

-- Type mapping so .vscode/launch.json is auto-loaded correctly
require('dap.ext.vscode').type_to_filetypes = {
  go          = { 'go' },
  ['pwa-node']= { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
}

require("mason-nvim-dap").setup({
	ensure_installed = {
		"delve",
		"js-debug-adapter",
	},
	automatic_installation = true,
	handlers = {
		function(config)
			require('mason-nvim-dap').default_setup(config)
		end,
	},
})

require("nvim-dap-virtual-text").setup({
	enabled = true,
	enabled_commands = true,
	highlight_changed_variables = true,
	highlight_new_as_changed = false,
	show_stop_reason = true,
	commented = false,
	only_first_definition = true,
	all_references = false,
	clear_on_continue = false,
	display_callback = function(variable, buf, stackframe, node, options)
		if options.virt_text_pos == 'inline' then
			return ' = ' .. variable.value
		else
			return variable.name .. ' = ' .. variable.value
		end
	end,
	virt_text_pos = vim.fn.has('nvim-0.10') == 1 and 'inline' or 'eol',
	all_frames = false,
	virt_lines = false,
	virt_text_win_col = nil,
})

local dapui = require("dapui")
dapui.setup({
	layouts = {
		{
			elements = {
				{ id = "scopes",  size = 0.40 },
				{ id = "stacks",  size = 0.40 },
				{ id = "watches", size = 0.20 },
			},
			position = "left",
			size = 40,
		},
		{
			elements = {
				{ id = "repl", size = 1.0 },
			},
			position = "bottom",
			size = 15,
		},
	},
})

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

vim.fn.sign_define('DapBreakpoint', { text = '✋', texthl = 'DiagnosticError' })
vim.fn.sign_define('DapBreakpointCondition', { text = '🚫', texthl = 'DiagnosticWarn' })
vim.fn.sign_define('DapBreakpointRejected', { text = '⛔', texthl = 'DiagnosticHint' })
vim.fn.sign_define('DapLogPoint', { text = '🟢', texthl = 'DiagnosticInfo' })

require("apascualco.plugins.dap.config")



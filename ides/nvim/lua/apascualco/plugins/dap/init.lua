local dap = require("dap")

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

require("dapui").setup()

vim.fn.sign_define('DapBreakpoint', { text = '✋', texthl = 'DiagnosticError' })
vim.fn.sign_define('DapBreakpointCondition', { text = '🚫', texthl = 'DiagnosticWarn' })
vim.fn.sign_define('DapBreakpointRejected', { text = '⛔', texthl = 'DiagnosticHint' })
vim.fn.sign_define('DapLogPoint', { text = '🟢', texthl = 'DiagnosticInfo' })

require("apascualco.plugins.dap.config")


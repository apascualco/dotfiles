local dap = require("dap")

vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "DiffChange" })
for name, sign in pairs({
	Stopped = { "󰁕 ", "DiagnosticSignWarn", "DapStoppedLine" },
	Breakpoint = { " " },
	BreakpointCondition = { " " },
	BreakpointRejected = { " ", "DiagnosticSignError" },
	LogPoint = { "󰯑 " },
}) do
	vim.fn.sign_define(
		"Dap" .. name,
		{ text = sign[1], texthl = sign[2] or "DiagnosticSignInfo", linehl = sign[3], numhl = sign[3] }
	)
end

dap.set_log_level(vim.env.NEOVIM_DAP_LOG_LEVEL or "WARN")

dap.defaults.fallback.terminal_win_cmd = function()
	local Terminal = require("toggleterm.terminal").Terminal
	local t = Terminal:new({ direction = "horizontal", close_on_exit = false })
	t:open()
	vim.api.nvim_set_current_win(vim.fn.bufwinid(t.bufnr))
	return t.bufnr, vim.fn.bufwinid(t.bufnr)
end

require("dap.ext.vscode").type_to_filetypes = {
	go = { "go" },
	python = { "python" },
	["pwa-node"] = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
	codelldb = { "rust" },
	lldb = { "rust" },
}

require("mason-nvim-dap").setup({
	ensure_installed = { "delve", "js-debug-adapter", "python", "codelldb", "javadbg", "javatest" },
	automatic_installation = true,
	handlers = {
		function(config)
			require("mason-nvim-dap").default_setup(config)
		end,
		codelldb = function() end,
		javadbg = function() end,
		javatest = function() end,
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
	display_callback = function(variable, _, _, _, options)
		if options.virt_text_pos == "inline" then
			return " = " .. variable.value
		end
		return variable.name .. " = " .. variable.value
	end,
	virt_text_pos = "inline",
	all_frames = false,
	virt_lines = false,
	virt_text_win_col = nil,
})

local dapui = require("dapui")
dapui.setup({
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 0.40 },
				{ id = "stacks", size = 0.40 },
				{ id = "watches", size = 0.20 },
			},
			position = "left",
			size = 40,
		},
		{ elements = { { id = "repl", size = 1.0 } }, position = "bottom", size = 15 },
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

require("apascualco.debug.js")
require("apascualco.debug.go")
require("apascualco.debug.rust")

local private = vim.uv.os_homedir() .. "/.local_nvim_dap.lua"
if vim.uv.fs_stat(private) then
	local ok, err = pcall(dofile, private)
	if not ok then
		vim.notify("dap: no se pudo cargar " .. private .. "\n" .. tostring(err), vim.log.levels.ERROR)
	end
end

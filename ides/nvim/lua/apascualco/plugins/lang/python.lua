return {
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			local dap_python = require("dap-python")
			dap_python.setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
			dap_python.resolve_python = function()
				return require("apascualco.lang.python.project").python_path()
			end
		end,
	},
}

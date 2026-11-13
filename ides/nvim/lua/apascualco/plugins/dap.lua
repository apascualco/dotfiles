return {
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"jay-babu/mason-nvim-dap.nvim",
			"mason-org/mason.nvim",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			require("apascualco.debug")
		end,
	},

	{ "LiadOz/nvim-dap-repl-highlights", opts = {} },
}

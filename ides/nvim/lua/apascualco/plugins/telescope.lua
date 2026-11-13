return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"benfowler/telescope-luasnip.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = { preview_width = 0.6, results_width = 0.4 },
					width = 0.9,
					height = 0.85,
				},
			},
		})
		telescope.load_extension("luasnip")
		telescope.load_extension("fzf")
	end,
}

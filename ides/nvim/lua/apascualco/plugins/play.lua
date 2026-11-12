return {
	{
		dir = vim.fn.stdpath("config") .. "/dev/apascualco-play.nvim",
		name = "apascualco-play.nvim",
		main = "apascualco-play",
		ft = { "go", "java", "python", "rust" },
		opts = {
			env = {
				go = function(buf)
					return require("apascualco.lang.go.main").env_file(vim.api.nvim_buf_get_name(buf))
				end,
			},
		},
	},
}

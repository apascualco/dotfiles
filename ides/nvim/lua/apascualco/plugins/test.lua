local function run(args_fn)
	return function()
		require("apascualco.lang").neotest_run(args_fn())
	end
end

return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"fredrikaverpil/neotest-golang",
		"nvim-neotest/neotest-python",
		"mrcjkb/rustaceanvim",
	},
	keys = {
		{ "<leader>nn", run(function()
			return vim.api.nvim_buf_get_name(0)
		end), desc = "Run nearest" },
		{ "<leader>nf", run(function()
			local f = vim.fn.expand("%:p")
			return f, { f }
		end), desc = "Run file" },
		{
			"<leader>na",
			run(function()
				local d = vim.fn.expand("%:p:h")
				return d, { d }
			end),
			desc = "Run all (package)",
		},
		{
			"<leader>nd",
			run(function()
				return vim.api.nvim_buf_get_name(0), { strategy = "dap" }
			end),
			desc = "Debug nearest",
		},
		{
			"<leader>nl",
			function()
				require("neotest").run.run_last()
			end,
			desc = "Run last",
		},
		{
			"<leader>ns",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Toggle summary",
		},
		{
			"<leader>no",
			function()
				require("neotest").output.open({ enter = true })
			end,
			desc = "Show output",
		},
		{
			"<leader>nw",
			function()
				local file = vim.fn.expand("%:p")
				require("neotest").watch.toggle(require("apascualco.lang").neotest_args(file, { file }))
			end,
			desc = "Toggle watch",
		},
	},
	config = function()
		local go = require("apascualco.lang.go.project")
		require("neotest").setup({
			adapters = {
				require("neotest-golang")({
					dap_mode = "dap-go",
					runner = "gotestsum",
					env = function()
						return go.test_env(vim.uv.cwd())
					end,
					go_test_args = function()
						return go.go_test_args()
					end,
					go_list_args = function()
						return go.go_list_args()
					end,
					dap_go_opts = go.dap_go_opts,
				}),
				require("neotest-python")({ dap = { justMyCode = false } }),
				require("rustaceanvim.neotest"),
			},
		})
	end,
}

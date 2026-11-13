return {
	{
		"NeogitOrg/neogit",
		dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
		opts = { integrations = { diffview = true }, graph_style = "unicode" },
	},

	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = { attach_to_untracked = true },
	},

	{ "sindrets/diffview.nvim", opts = { hg_cmd = nil } },

	{
		"CoreyKaylor/diffbandit.nvim",
		cmd = {
			"DiffBanditGit",
			"DiffBanditGitCurrent",
			"DiffBanditGitMenu",
			"DiffBanditGitLog",
			"DiffBanditGitCompare",
			"DiffBanditCommitPanel",
		},
		keys = {
			{ "<leader>gzm", "<cmd>DiffBanditGitMenu<CR>", desc = "Git menu" },
			{ "<leader>gzg", "<cmd>DiffBanditGit<CR>", desc = "Working tree changes" },
			{ "<leader>gzc", "<cmd>DiffBanditGitCurrent<CR>", desc = "Diff current file" },
			{ "<leader>gzr", "<cmd>DiffBanditGitCompare origin/main HEAD<CR>", desc = "Review branch vs main" },
			{ "<leader>gzl", "<cmd>DiffBanditGitLog<CR>", desc = "Commit log" },
			{ "<leader>gzp", "<cmd>DiffBanditCommitPanel<CR>", desc = "Commit panel" },
		},
		opts = {},
	},

	{
		"akinsho/git-conflict.nvim",
		version = "*",
		event = "BufReadPre",
		opts = { default_mappings = true, disable_diagnostics = true },
	},

	{
		"pwntester/octo.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "nvim-tree/nvim-web-devicons" },
		cmd = "Octo",
		keys = {
			{ "<leader>Oo", "<cmd>Octo<cr>", desc = "Octo menu" },
			{ "<leader>Op", "<cmd>Octo pr list<cr>", desc = "Pull requests" },
			{ "<leader>OP", "<cmd>Octo pr search<cr>", desc = "Search PRs" },
			{ "<leader>Oi", "<cmd>Octo issue list<cr>", desc = "Issues" },
			{ "<leader>Or", "<cmd>Octo review start<cr>", desc = "Start review" },
		},
		opts = { picker = "telescope" },
	},

	{
		"aaronhallaert/advanced-git-search.nvim",
		cmd = "AdvancedGitSearch",
		dependencies = { "nvim-telescope/telescope.nvim", "tpope/vim-fugitive" },
		keys = {
			{ "<leader>gA", "<cmd>AdvancedGitSearch<cr>", desc = "Advanced search" },
		},
		config = function()
			require("telescope").load_extension("advanced_git_search")
		end,
	},
}

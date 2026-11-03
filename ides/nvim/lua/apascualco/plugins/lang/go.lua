return {
	{
		"ray-x/go.nvim",
		dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },
		ft = { "go", "gomod" },
		cmd = { "GoInstallBinaries", "GoUpdateBinaries", "GoTagAdd", "GoTagRm", "GoImpl", "GoCoverage", "GoDoc" },
		build = ':lua require("go.install").update_all_sync()',
		config = function()
			local gopath = vim.fn.trim(vim.fn.system("go env GOPATH"))
			local gobin = gopath .. "/bin"
			vim.env.GOPATH = gopath
			vim.env.GOBIN = gobin
			if not string.find(vim.env.PATH or "", gobin, 1, true) then
				vim.env.PATH = gobin .. ":" .. (vim.env.PATH or "")
			end
			require("go").setup({
				lsp_cfg = false,
				lsp_on_attach = false,
				lsp_keymaps = false,
				lsp_inlay_hints = { enable = false },
				diagnostic = false,
				go = "go",
				gopath = gopath,
				gobin = gobin,
				lsp_gofumpt = true,
				luasnip = true,
			})
		end,
	},

	{
		"leoluz/nvim-dap-go",
		ft = "go",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function(_, opts)
			require("dap-go").setup(opts)
			local dap = require("dap")
			for _, config in ipairs(dap.configurations.go or {}) do
				if config.request == "launch" and not config.console then
					config.console = "integratedTerminal"
				end
				if config.mode == "auto" then
					config.mode = "debug"
				end
			end
			table.insert(dap.configurations.go, {
				type = "go_remote",
				name = "Attach: Delve en Docker (:2345, make dev-debug)",
				request = "attach",
				mode = "remote",
				port = 2345,
				substitutePath = function()
					local root = vim.fs.root(0, "go.mod") or vim.fn.getcwd()
					return { { from = root, to = "/app" } }
				end,
			})
		end,
	},
}

return {
	{
		"mrcjkb/rustaceanvim",
		lazy = false,
		init = function()
			vim.g.rustaceanvim = {
				tools = { executor = "toggleterm", test_executor = "neotest" },
				server = {
					default_settings = {
						["rust-analyzer"] = {
							cargo = { features = "all", buildScripts = { enable = true } },
							procMacro = { enable = true },
							check = { command = "clippy" },
							rustfmt = { extraArgs = { "+stable" } },
							diagnostics = { enable = true },
							inlayHints = {
								chainingHints = { enable = true },
								parameterHints = { enable = true },
								typeHints = { enable = true },
							},
							completion = { autoimport = { enable = true } },
							imports = { granularity = { group = "module" }, prefix = "self" },
						},
					},
				},
			}
		end,
	},

	{
		"saecki/crates.nvim",
		tag = "stable",
		event = { "BufRead Cargo.toml" },
		config = function()
			local crates = require("crates")
			crates.setup({
				completion = { cmp = { enabled = true }, crates = { enabled = true } },
				lsp = { enabled = true, actions = true, completion = false, hover = true },
			})
			local function set_keymaps(buf)
				local function m(lhs, fn, desc)
					vim.keymap.set("n", lhs, fn, { buffer = buf, silent = true, desc = desc })
				end
				m("<leader>Ct", crates.toggle, "Toggle inline info")
				m("<leader>Cr", crates.reload, "Reload")
				m("<leader>Cv", crates.show_versions_popup, "Versions")
				m("<leader>Cf", crates.show_features_popup, "Features")
				m("<leader>Cd", crates.show_dependencies_popup, "Dependencies")
				m("<leader>Cu", crates.update_crate, "Update crate")
				m("<leader>Ca", crates.update_all_crates, "Update all")
				m("<leader>CU", crates.upgrade_crate, "Upgrade crate")
				m("<leader>CA", crates.upgrade_all_crates, "Upgrade all")
				m("<leader>Co", crates.open_crates_io, "Open on crates.io")
				m("<leader>CD", crates.open_documentation, "Open docs.rs")
			end
			local cur = vim.api.nvim_get_current_buf()
			if vim.fn.fnamemodify(vim.api.nvim_buf_get_name(cur), ":t") == "Cargo.toml" then
				set_keymaps(cur)
			end
			vim.api.nvim_create_autocmd("BufRead", {
				pattern = "Cargo.toml",
				callback = function(ev)
					set_keymaps(ev.buf)
				end,
			})
		end,
	},
}

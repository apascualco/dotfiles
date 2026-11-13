return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"onsails/lspkind.nvim",
			{ "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()
			local select_opts = { behavior = cmp.SelectBehavior.Select }
			local menu_icon = {
				nvim_lsp = "[LSP]",
				nvim_lsp_signature_help = "[SIG]",
				luasnip = "[SNIP]",
				buffer = "[BUF]",
				path = "[PATH]",
				crates = "[CRATE]",
			}

			cmp.setup({
				view = { docs = { auto_open = true } },
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				sources = cmp.config.sources({
					{ name = "lazydev", group_index = 0 },
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "luasnip", priority = 900 },
					{ name = "path", priority = 700 },
					{ name = "crates", priority = 650 },
					{ name = "buffer", priority = 500 },
				}),
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					format = require("lspkind").cmp_format({
						mode = "symbol",
						maxwidth = 50,
						ellipsis_char = "...",
						before = function(entry, item)
							item.menu = menu_icon[entry.source.name]
							return item
						end,
					}),
				},
				mapping = {
					["<Up>"] = cmp.mapping.select_prev_item(select_opts),
					["<Down>"] = cmp.mapping.select_next_item(select_opts),
					["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
					["<C-n>"] = cmp.mapping.select_next_item(select_opts),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-h>"] = cmp.mapping(function()
						if cmp.visible_docs() then
							cmp.close_docs()
						else
							cmp.open_docs()
						end
					end),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<C-f>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-b>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<Tab>"] = cmp.mapping(function(fallback)
						local col = vim.fn.col(".") - 1
						if cmp.visible() then
							cmp.select_next_item(select_opts)
						elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
							fallback()
						else
							cmp.complete()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item(select_opts)
						else
							fallback()
						end
					end, { "i", "s" }),
				},
			})

			cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
				sources = cmp.config.sources({
					{ name = "vim-dadbod-completion", priority = 1000 },
					{ name = "luasnip", priority = 900 },
					{ name = "buffer", priority = 500 },
				}),
			})
		end,
	},

	{
		"milanglacier/minuet-ai.nvim",
		enabled = false,
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("apascualco.ai.minuet")
		end,
	},
}

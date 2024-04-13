local lspconfig = require('lspconfig')
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local util = require("lspconfig/util")

lspconfig.rust_analyzer.setup({ 
  cmd = { "rust-analyzer" },
	root_dir = util.root_pattern("Cargo.toml", "rust-project.json"),
	filetypes = { "rust" },
  settings = {
     ["rust-analyzer"] = {
        imports = {
           granularity = {
              group = "module",
           },
           prefix = "self",
        },
        cargo = {
           buildScripts = {
              enable = true,
           },
        },
        procMacro = {
           enable = true
        },
     }
  },
  capabilities = capabilities
})

local autocmd = vim.api.nvim_create_autocmd

autocmd( { "BufNewFile", "BufRead" }, {
  pattern = { "*.rs" },
  command = [[ set filetype=rust]],
})

-- autocmd FileType go nnoremap<buffer> <Leader>T :call GoFunction()
autocmd('FileType', {
	pattern = 'rust',
	callback = function ()
		vim.keymap.set('n', 'er', ':RustRun<CR>', { silent = true, buffer = true })
	end,
})
--set("n", "ghs", "<Plug>(GitGutterStageHunk)", { desc = "Add to stage the line hover" })

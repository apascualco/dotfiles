local lspconfig = require('lspconfig')
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.rust_analyzer.setup({ 
  settings = {
    ['rust-analyzer'] = {},
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

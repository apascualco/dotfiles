-- nvim-treesitter new API (nvim 0.12+)
-- El módulo 'nvim-treesitter.configs' fue eliminado.
-- Highlighting, indent y folding son ahora nativos de nvim.
-- Este plugin solo gestiona la instalación de parsers.

require('nvim-treesitter').setup()

-- Instalar parsers al arrancar (async)
vim.api.nvim_create_autocmd('User', {
	pattern = 'VeryLazy',
	once = true,
	callback = function()
		require('nvim-treesitter').install({
			'bash',
			'c',
			'cmake',
			'css',
			'cpp',
			'diff',
			'dockerfile',
			'gitignore',
			'git_rebase',
			'go',
			'gomod',
			'gowork',
			'gosum',
			'gotmpl',
			'html',
			'java',
			'json',
			'json5',
			'kotlin',
			'lua',
			'make',
			'markdown',
			'python',
			'regex',
			'ruby',
			'rust',
			'scala',
			'scss',
			'slint',
			'tsx',
			'toml',
			'sql',
			'vim',
			'yaml',
			'terraform',
			'javascript',
			'typescript',
			'comment',
			'dap_repl',
			'markdown_inline',
		})
	end,
})

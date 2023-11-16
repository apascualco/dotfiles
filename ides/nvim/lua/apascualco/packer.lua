vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use { "wbthomason/packer.nvim" }
	use { 'nvim-tree/nvim-web-devicons' }
	use { 'nvim-tree/nvim-tree.lua' }
	-- use { 'neoclide/coc.nvim', branch = 'release' }
	use { 'catppuccin/nvim', as = "catppuccin" }
	use { 'vim-airline/vim-airline' }
	use { 'vim-airline/vim-airline-themes' }
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.2',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}
	use { 'preservim/tagbar' }

	use { 'neovim/nvim-lspconfig'}
	use { 'jose-elias-alvarez/null-ls.nvim' }
	use { 'hrsh7th/nvim-cmp' }
	use { 'hrsh7th/cmp-nvim-lsp' }
  	use { 'saadparwaiz1/cmp_luasnip' }
  	use { 'L3MON4D3/LuaSnip' }

	use { 'airblade/vim-gitgutter' }
	use { 'mtdl9/vim-log-highlighting' }
end)

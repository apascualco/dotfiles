vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use { "wbthomason/packer.nvim" }
	use 'nvim-tree/nvim-web-devicons'
	use 'nvim-tree/nvim-tree.lua'
	use { 'neoclide/coc.nvim', branch = 'release' }
	use { 'catppuccin/nvim', as = "catppuccin" }
	use 'vim-airline/vim-airline'
	use 'vim-airline/vim-airline-themes'
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}
end)

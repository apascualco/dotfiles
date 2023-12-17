vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use { "wbthomason/packer.nvim" }
	use { 'nvim-tree/nvim-web-devicons' }
	use { 'nvim-tree/nvim-tree.lua' }
	use { 'catppuccin/nvim', as = "catppuccin" }
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}
  use {
    "lazytanuki/nvim-mapper",
    config = function() require("nvim-mapper").setup{} end,
    before = "telescope.nvim"
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/plenary.nvim'}},
    config = function() 
      require("telescope").load_extension("mapper") 
      require("telescope").load_extension("luasnip") 
    end
  }
	use { 'preservim/tagbar' }

	use { 'neovim/nvim-lspconfig'}
	use { 'jose-elias-alvarez/null-ls.nvim' }
	use { 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/cmp-nvim-lsp' }
	use { 'hrsh7th/cmp-buffer' }
	use { 'hrsh7th/cmp-path' }
  use { 'saadparwaiz1/cmp_luasnip' }
  use { 'L3MON4D3/LuaSnip' }
  use { 'rafamadriz/friendly-snippets' }

  use { 'onsails/lspkind.nvim' }

	use { 'airblade/vim-gitgutter' }
	use { 'mtdl9/vim-log-highlighting' }

  use {
    'nvim-lualine/lualine.nvim',
    requires = {
      'arkav/lualine-lsp-progress',
    },
  }

  use { 'arkav/lualine-lsp-progress' }
  use { 'mfussenegger/nvim-dap' }
  use { 'theHamsta/nvim-dap-virtual-text' }
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
  use { 'jpmcb/nvim-llama' }
  use { "benfowler/telescope-luasnip.nvim" }
  use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}
  use { 'dstein64/vim-startuptime' }

end)

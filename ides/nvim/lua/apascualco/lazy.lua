require("lazy").setup({
  -- Directory manager
  'nvim-tree/nvim-tree.lua',

  -- Theme apparence
	'nvim-tree/nvim-web-devicons',
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },

  -- Highlighting of code
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

  -- Mapper to telescope the shortcuts
  {
    'lazytanuki/nvim-mapper',
    config = function() require('nvim-mapper').setup{} end,
  },

  -- Diagnostics
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },

  -- Seacrh and find dirs, snips, mappers, etc...
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      {'nvim-lua/plenary.nvim'},
      { 'benfowler/telescope-luasnip.nvim' }
    },
    config = function()
      require('telescope').load_extension('mapper')
      require('telescope').load_extension('luasnip')
    end
  },
  -- browse the tags 
	{ 'preservim/tagbar' },

  -- Language Server Protocol
	{ 'neovim/nvim-lspconfig'},
  { 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/cmp-buffer' },
	{ 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
	{ 'hrsh7th/nvim-cmp' },

  -- LSP installer
  { 'williamboman/mason.nvim' },

  -- Snippers
  { 'L3MON4D3/LuaSnip' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'hrsh7th/cmp-vsnip' },
  { 'hrsh7th/vim-vsnip' },
  { 'SirVer/ultisnips' },
  { 'quangnguyen30192/cmp-nvim-ultisnips' },
  { 'dcampos/nvim-snippy' },
  { 'dcampos/cmp-snippy' },

  -- Vscode-like pictograms
  { 'onsails/lspkind.nvim' },

  -- Git
  { 'tpope/vim-fugitive' },
	{ 'airblade/vim-gitgutter' },

  -- Colored logs
	{ 'mtdl9/vim-log-highlighting' },

  -- Botton line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'arkav/lualine-lsp-progress',
    },
  },

  -- Debug adapter protocol
  { 'mfussenegger/nvim-dap' },
  { 'theHamsta/nvim-dap-virtual-text' },
  { 'rcarriga/nvim-dap-ui', dependencies = { 'mfussenegger/nvim-dap' } },

  -- IA
  { 'jpmcb/nvim-llama' },

  -- Tabs extra information
  {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},

  { 'dstein64/vim-startuptime' },

  -- Terminal
  {
    'willothy/flatten.nvim',
    config = true,
    lazy = false,
    priority = 1001,
  },

  -- Surround shortcuts
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
        require('nvim-surround').setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  },

  -- Underline same words
  {
    'sontungexpt/stcursorword',
    event = 'VeryLazy',
    config = true,
  },
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function ()
      require('octo').setup()
    end
  },
  {
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false,
  },
  { 'simrat39/rust-tools.nvim' }
})

--require('k8s').setup({})


--     Old text                    Command         New text
--------------------------------------------------------------------------------
--    surr*ound_words             ysiw)           (surround_words)
--    *make strings               ys$"            "make strings"
--    [delete ar*ound me!]        ds]             delete around me!
--    remove <b>HTML t*ags</b>    dst             remove HTML tags
--    'change quot*es'            cs'"            "change quotes"
--    <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
--    delete(functi*on calls)     dsf             function calls

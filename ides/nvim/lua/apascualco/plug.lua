local Plug = vim.fn['plug#']
local call = vim.call
local fn = vim.fn

call('plug#begin', '~/.config/nvim/plugged')

-- Nvim tree
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-tree/nvim-tree.lua')
--

Plug('neoclide/coc.nvim', {['branch'] = 'release'})

Plug('catppuccin/nvim', { ['as'] =  'catppuccin' })

Plug('vim-airline/vim-airline')
Plug('vim-airline/vim-airline-themes')

Plug('nvim-treesitter/nvim-treesitter', {['do'] = fn[':TSUpdate']})

call('plug#end')

require("apascualco.nvim-tree")
require("apascualco.coc")
require("apascualco.catppuccin")
require("apascualco.airline")
require("apascualco.treesitter")

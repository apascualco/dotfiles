local Plug = vim.fn['plug#']
local call = vim.call
local fn = vim.fn

call('plug#begin', '~/.config/nvim/plugged')

-- Nvim tree
Plug('nvim-tree/nvim-web-devicons')
-- Plug('nvim-tree/nvim-tree.lua')
--
-- Plug('nvim-lua/plenary.nvim')
-- Plug('nvim-telescope/telescope.nvim', { ['bramch'] = 'master' })
-- Plug ('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' })

-- Plug('neoclide/coc.nvim', {['branch'] = 'release'})

-- Plug('catppuccin/nvim', { ['as'] =  'catppuccin' })

-- Plug('vim-airline/vim-airline')
-- Plug('vim-airline/vim-airline-themes')

-- Plug('nvim-treesitter/nvim-treesitter', {['do'] = fn[':TSUpdate']})

-- Plug('airblade/vim-gitgutter')
-- .Plug('mtdl9/vim-log-highlighting')
-- Plug('preservim/tagbar')


call('plug#end')

require("apascualco.nvim-tree")
require("apascualco.coc")
require("apascualco.catppuccin")
require("apascualco.airline")
require("apascualco.treesitter")
require("apascualco.telescope")

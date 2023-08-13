local g = vim.g
local set = vim.keymap.set

g.mapleader = ','

-- Nvim-tree
set("n", "tt", ":NvimTreeFindFile<CR>")
set("n", "<C-t>", ":NvimTreeToggle<CR>")


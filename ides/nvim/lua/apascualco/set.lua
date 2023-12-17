local g = vim.g
local set = vim.keymap.set

g.mapleader = ','

set("n", "tt", ":NvimTreeFindFile<CR>")
set("n", "<C-t>", ":NvimTreeToggle<CR>")


set("n", "ghs", "<Plug>(GitGutterStageHunk)")
set("n", "ghu", "<Plug>(GitGutterUndoHunk)")

set("n", ">>", ":bn<CR>")
set("n", "<<", ":bp<CR>")

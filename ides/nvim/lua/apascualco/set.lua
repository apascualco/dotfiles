local g = vim.g
local set = vim.keymap.set

g.mapleader = ','

set("n", "ghs", "<Plug>(GitGutterStageHunk)", { desc = "Add to stage the line hover" })
set("n", "ghu", "<Plug>(GitGutterUndoHunk)", { desc = "Rollback change" })

set("n", ">>", ":bn<CR>")
set("n", "<<", ":bp<CR>")

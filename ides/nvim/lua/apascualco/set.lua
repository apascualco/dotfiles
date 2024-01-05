local g = vim.g
local set = vim.keymap.set

g.mapleader = ','

set("n", "ghs", "<Plug>(GitGutterStageHunk)", { desc = "Add to stage the line hover" })
set("n", "ghn", "<Plug>(GitGutterNextHunk)", { desc = "Add to stage the line hover" })
set("n", "ghu", "<Plug>(GitGutterUndoHunk)", { desc = "Rollback change" })
set("n", "ghd", ":Gdiffsplit<CR>", { desc = "Horizontal split with diff GIT" })
set("n", "ghc", ":Git commit<CR>", { desc = "Git commit" })
set("n", "ghp", ":Git push<CR>", { desc = "Git push" })
set("n", "ghb", ":Git blame<CR>", { desc = "Git blame" })

set("n", ">>", ":bn<CR>")
set("n", "<<", ":bp<CR>")

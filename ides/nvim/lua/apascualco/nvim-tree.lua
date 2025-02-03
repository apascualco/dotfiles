-- Disabling netrw is strongly advised, see :help nvim-tree-netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 40,
  },
  renderer = {
    highlight_diagnostics = true,
    group_empty = true,
  },
  filters = {
    git_ignored = false
  },
  diagnostics = {
    enable = true,
    show_on_dirs = false,
  },
})

local set = vim.keymap.set

-- g? to show help
set("n", "n", ":NvimTreeToggle<CR>", { desc = "" })
set("n", "tt", ":NvimTreeFindFile<CR>", { desc = "Go to current file (nvim-tree)" })
set("n", "tc", ":NvimTreeClose<CR>", { desc = "Toggle nvim-tree if are in the file (close)" })
set("n", "tcc", ":NvimTreeCollapse<CR>", { desc = "Collapse nvim-tree" })

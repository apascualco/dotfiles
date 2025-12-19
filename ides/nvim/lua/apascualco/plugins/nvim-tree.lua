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
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
})
vim.g.nvim_tree_respect_buf_cwd = 1

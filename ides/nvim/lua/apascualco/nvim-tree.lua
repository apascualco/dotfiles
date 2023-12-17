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

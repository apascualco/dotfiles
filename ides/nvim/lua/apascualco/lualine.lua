require("lualine").setup({
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "filename" },
    lualine_c = { "lsp_progress" },
  }
})

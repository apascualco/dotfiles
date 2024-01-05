require("nvim-treesitter.configs").setup({
  modules = {},
  sync_install = false,
  auto_install = true,
  ignore_install = {},
  highlight = {
    enable = true,
    custom_captures = {},
    additional_vim_regex_highlighting = false,
  },
  ensure_installed = {
    "bash",
    "c",
    "cmake",
    "css",
    "cpp",
    "diff",
    "dockerfile",
    "gitignore",
    "git_rebase",
    "go",
    "html",
    "java",
    "json",
    "json5",
    "kotlin",
    "lua",
    "make",
    "markdown",
    "python",
    "regex",
    "ruby",
    "rust",
    "scala",
    "scss",
    "slint",
    "tsx",
    "toml",
    "sql",
    "vim",
    "yaml",
    "terraform",
    "javascript",
    "typescript",
    "tsx",
    "rust"
  }
})

local opt = vim.opt

opt.foldmethod = "expr"
opt.foldexpr = "(getline(v:lnum)=~'^import')"

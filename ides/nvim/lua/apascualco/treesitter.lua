require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    custom_captures = {
      -- ["foo.bar"] = "Identifier",
    },
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
    "tsx"
  }
})

local opt = vim.opt

opt.foldmethod = "expr"
opt.foldexpr = "(getline(v:lnum)=~'^import')"

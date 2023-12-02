require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ["foo.bar"] = "Identifier",
    },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
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
}


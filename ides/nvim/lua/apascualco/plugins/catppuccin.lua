require("catppuccin").setup({
    flavour = nil, -- latte, frappe, macchiato, mocha
    background = {
        light = "latte",
        dark = "macchiato",
    },
    transparent_background = false,
    show_end_of_buffer = false,
    term_colors = false,
    dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
    },
    no_italic = false,
    no_bold = false,
    no_underline = false,
    styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    color_overrides = {},
    custom_highlights = {},
    integrations = {
      octo = true,
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      telescope = true,
      notify = true,
      mini = false,
      lsp_trouble = true,
      treesitter = true,
      dap = { enabled = true, enable_ui = true },
      which_key = true,
      indent_blankline = { enabled = true, colored_indent_levels = true },
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
    },
})

vim.cmd.colorscheme("catppuccin")

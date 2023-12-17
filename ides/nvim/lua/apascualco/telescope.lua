require("telescope").setup({
  defaults = {
    layout_strategy = 'vertical',
    layout_config = { 
      vertical = {
        height = 0.9,
        prompt_position = "top",
        width = 0.9
      },
    }
  }
})

local builtin = require('telescope.builtin')
local keyset = vim.keymap.set
keyset('n', 'tf', builtin.find_files, {})
keyset('n', 'tg', builtin.live_grep, {})
keyset('n', 'tb', builtin.buffers, {})
keyset('n', 'th', builtin.help_tags, {})
keyset('n', 'tk', builtin.keymaps, {})

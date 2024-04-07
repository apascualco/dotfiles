require("telescope").setup({
  defaults = {
    layout_strategy = 'vertical',
    layout_config = { 
      vertical = {
        height = 0.9,
        prompt_position = "top",
        width = 0.9
      },
    },
    file_ignore_patterns = { 
      "^vendor/",
      "/vendor/"
    }
  }
})

local builtin = require('telescope.builtin')
local set = vim.keymap.set
set('n', 'tf', builtin.find_files, { desc = "Search find files"})
set('n', 'tg', builtin.live_grep, { desc = "Search with grep"})
set('n', 'tb', builtin.buffers, { desc = "Search in buffers"})
set('n', 'th', builtin.help_tags, { desc = "Search help tags"})
set('n', 'tk', builtin.keymaps, { desc = "Search keymaps"})

local builtin = require('telescope.builtin')
local keyset = vim.keymap.set
keyset('n', 'ff', builtin.find_files, {})
keyset('n', 'fg', builtin.live_grep, {})
keyset('n', 'fb', builtin.buffers, {})
keyset('n', 'fh', builtin.help_tags, {})

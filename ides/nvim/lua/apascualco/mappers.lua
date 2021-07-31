local function rmap(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function map(mode, lhs, rhs)
  vim.api.nvim_set_keymap(mode, lhs, rhs, {})
end
--
-- Prefix G
-- Git <fugitive> gs -> status | gf -> accept left | gj -> accept right
map('n', 'gs', ':G')
map('n', 'gf', ':diffget //2')
map('n', 'gj', ':diffget //3')
map('n', 'gp', ':Git push')
map('n', 'gps', ':Git -c push.default=current push<cr>')

map('n', 'ghu', '<Plug>(GitGutterUndoHunk)')
map('n', 'ghs', '<Plug>(GitGutterStageHunk)')

-- Movement coc into code
map('n', '<silent> gd', '<Plug>(coc-definition)')
map('n', '<silent> gy', '<Plug>(coc-type-definition)')
map('n', '<silent> gi', '<Plug>(coc-implementation)')
map('n', '<silent> gr', '<Plug>(coc-references)')
map('n', '<silent> [g', '<Plug>(coc-diagnostic-prev)')
map('n', '<silent> ]g', '<Plug>(coc-diagnostic-next)')

-- Prefix R
map('n', '<leader>rn', '<Plug>(coc-rename)')

-- Prefix T
map('n', 'tb', ':TagbarToggle')

-- Prefix B
rmap('n', 'b', ':buffers<CR>:buffer')
rmap('n', 'bn', ':bn<CR>')
rmap('n', 'bp', ':bp<CR>')
rmap('n', 'bd', ':bd<CR>')

-- Prefix K
rmap('n', '<silent> K :call', '<SID>show_documentation()<CR>')

-- Prefix T
rmap('n', 'tt', ':NERDTreeFind')

-- Prefix F
rmap('n', 'ff', '<cmd>Telescope find_files<CR>')
rmap('n', 'fg', '<cmd>Telescope live_grep<CR>')
rmap('n', 'fb', '<cmd>Telescope buffers<CR>')
rmap('n', 'fh', '<cmd>Telescope help_tags<CR>')
rmap('n', 'fn', ':FloatermNew<CR>')
rmap('n', 'ft', ':FloatermToggle<CR>')
rmap('n', 'fp', ':FloatermPrev<CR>')

-- Resize
rmap('n', '<leader>+', ':vertical resize -5<CR>')
rmap('n', '<leader>-', ':vertical resize -5<CR>')

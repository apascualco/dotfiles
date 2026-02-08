-- keybinding.lua — curated keymaps for NvimTree, Telescope, LSP, lint/format, Trouble, DAP, Git, Diffview, Spectre, Harpoon
-- Estilo: vim.keymap.set “plano”, descripciones en inglés, noremap+silent.

local set = vim.keymap.set
local function map(mode, lhs, rhs, desc)
  set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- ──────────────────────────────────────────────────────────────────────────────
-- NvimTree
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>e',  '<cmd>NvimTreeToggle<CR>',   'NvimTree — Toggle file explorer')
map('n', '<leader>ef', '<cmd>NvimTreeFocus<CR>',    'NvimTree — Focus file explorer')
map('n', '<leader>ee', '<cmd>NvimTreeFindFile<CR>', 'NvimTree — Reveal current file')
map('n', '<leader>ec', '<cmd>NvimTreeCollapse<CR>', 'NvimTree — Collapse all nodes')
map('n', '<leader>er', '<cmd>NvimTreeRefresh<CR>',  'NvimTree — Refresh tree')

-- ──────────────────────────────────────────────────────────────────────────────
-- Telescope (require inside function → avoids rhs=nil if not loaded yet)
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>ff', function() require('telescope.builtin').find_files() end, 'Telescope — Find files')
map('n', '<leader>fF', function() require('telescope.builtin').find_files({ no_ignore = true, hidden = true }) end,
  'Telescope — Find files (include hidden, no_ignore)')
map('n', '<leader>fg', function() require('telescope.builtin').live_grep() end,  'Telescope — Live grep')
map('n', '<leader>fs', function() require('telescope.builtin').grep_string() end,'Telescope — Grep word under cursor')
map('n', '<leader>f/', function() require('telescope.builtin').current_buffer_fuzzy_find() end,
  'Telescope — Fuzzy search in current buffer')
map('n', '<leader>fb', function() require('telescope.builtin').buffers() end,    'Telescope — Switch buffer')
map('n', '<leader>fo', function() require('telescope.builtin').oldfiles() end,   'Telescope — Recent files')
map('n', '<leader>fh', function() require('telescope.builtin').help_tags() end,  'Telescope — Help tags')
map('n', '<leader>fk', function() require('telescope.builtin').keymaps() end,    'Telescope — Keymaps')
map('n', '<leader>fc', function() require('telescope.builtin').commands() end,   'Telescope — :commands')
map('n', '<leader>f:', function() require('telescope.builtin').command_history() end, 'Telescope — Command history')
map('n', '<leader>f?', function() require('telescope.builtin').search_history() end,  'Telescope — Search history')
map('n', '<leader>fr', function() require('telescope.builtin').resume() end,     'Telescope — Resume last picker')
map('n', '<leader>frg', function() require('telescope.builtin').registers() end, 'Telescope — Registers')

-- Git (Telescope)
map('n', '<leader>gs', function() require('telescope.builtin').git_status() end,    'Telescope — Git status')
map('n', '<leader>gb', function() require('telescope.builtin').git_branches() end,  'Telescope — Git branches')
map('n', '<leader>gc', function() require('telescope.builtin').git_commits() end,   'Telescope — Git commits (repo)')
map('n', '<leader>gC', function() require('telescope.builtin').git_bcommits() end,  'Telescope — Git commits (current buffer)')

-- LSP (Telescope) — sin duplicar con LSP nativo
map('n', '<leader>lr', function() require('telescope.builtin').lsp_references() end,          'Telescope — LSP references')
map('n', '<leader>li', function() require('telescope.builtin').lsp_implementations() end,     'Telescope — LSP implementations')
map('n', '<leader>ls', function() require('telescope.builtin').lsp_document_symbols() end,    'Telescope — LSP document symbols')
map('n', '<leader>lS', function() require('telescope.builtin').lsp_workspace_symbols() end,   'Telescope — LSP workspace symbols')
map('n', '<leader>dd', function() require('telescope.builtin').diagnostics() end,             'Telescope — Diagnostics')

-- Extensiones de Telescope
map('n', '<leader>ss', function() require('telescope').extensions.luasnip.luasnip() end,
  'Telescope (luasnip) — Browse & insert snippets')
map('n', '<leader>km', function() require('telescope').extensions.mapper.mapper() end,
  'Telescope (mapper) — Browse custom keymaps')
map('n', '<leader>fn', function() require('telescope.builtin').notify_history() end,
  'Telescope — Notification history')

-- ──────────────────────────────────────────────────────────────────────────────
-- Tagbar
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>tt', '<cmd>TagbarToggle<CR>', 'Tagbar — Toggle symbol/class outline')
map('n', '<leader>to', '<cmd>TagbarOpen<CR>',   'Tagbar — Open Tagbar window')

-- ──────────────────────────────────────────────────────────────────────────────
-- LSP core (nativo)
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>lI', '<cmd>LspInfo<CR>',                       'LSPConfig — Show active LSP clients')
map('n', '<leader>lm', '<cmd>Mason<CR>',                         'Mason — Open package manager UI')
map('n', '<leader>la', vim.lsp.buf.code_action,                  'LSP — Code actions')
map('n', '<leader>lR', vim.lsp.buf.rename,                       'LSP — Rename symbol')  -- cambiado a lR (R mayúscula)
map('n', '<leader>lD', vim.lsp.buf.declaration,                  'LSP — Go to declaration')
map('n', '<leader>ld', vim.lsp.buf.definition,                   'LSP — Go to definition')
map('n', '<leader>lt', vim.lsp.buf.type_definition,              'LSP — Go to type definition')
map('n', '<leader>lh', vim.lsp.buf.hover,                        'LSP — Hover documentation')
map('n', '<leader>lK', vim.lsp.buf.signature_help,               'LSP — Function signature help')
map('n', '<leader>lf', function() vim.lsp.buf.format({ async = true }) end, 'LSP — Format current buffer')
map('n', '[d', vim.diagnostic.goto_prev,                         'LSP — Previous diagnostic')
map('n', ']d', vim.diagnostic.goto_next,                         'LSP — Next diagnostic')
map('n', '<leader>le', vim.diagnostic.open_float,                'LSP — Show diagnostic under cursor')
map('n', '<leader>lq', vim.diagnostic.setloclist,                'LSP — Populate location list with diagnostics')
map('x', '<leader>la', function() vim.lsp.buf.code_action() end, 'LSP — Code actions (visual range)')

-- ──────────────────────────────────────────────────────────────────────────────
-- nvim-cmp + LuaSnip
-- ──────────────────────────────────────────────────────────────────────────────
map('i', '<C-Space>', '<cmd>lua require("cmp").complete()<CR>',          'nvim-cmp — Trigger completion')
map('i', '<C-y>',     '<cmd>lua require("cmp").confirm({ select = true })<CR>',
  'nvim-cmp — Confirm completion (select if none)')
map('i', '<C-e>',     '<cmd>lua require("cmp").abort()<CR>',             'nvim-cmp — Abort completion')
map({'i','s'}, '<C-j>', function() require('luasnip').jump(1) end,       'LuaSnip — Jump to next snippet node')
map({'i','s'}, '<C-k>', function() require('luasnip').jump(-1) end,      'LuaSnip — Jump to previous snippet node')

-- ──────────────────────────────────────────────────────────────────────────────
-- nvim-lint
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>ll', function() require('lint').try_lint() end,        'nvim-lint — Run linter on current file')

-- ──────────────────────────────────────────────────────────────────────────────
-- conform.nvim
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>cf', function() require('conform').format({ async = true, lsp_fallback = true }) end,
  'conform.nvim — Format current file')

-- ──────────────────────────────────────────────────────────────────────────────
-- Trouble
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>xx',  '<cmd>Trouble diagnostics toggle<CR>',                    'Trouble — Toggle diagnostics (workspace)')
map('n', '<leader>xd',  '<cmd>Trouble diagnostics toggle filter.buf=0<CR>',       'Trouble — Toggle diagnostics (current buffer)')
map('n', '<leader>xl',  '<cmd>Trouble loclist toggle<CR>',                        'Trouble — Toggle location list')
map('n', '<leader>xq',  '<cmd>Trouble qflist toggle<CR>',                         'Trouble — Toggle quickfix list')
map('n', '<leader>xs',  '<cmd>Trouble symbols toggle focus=false<CR>',            'Trouble — Toggle document symbols')
map('n', '<leader>xlp', '<cmd>Trouble lsp toggle focus=false<CR>',                'Trouble — Toggle LSP panel')

-- ──────────────────────────────────────────────────────────────────────────────
-- nvim-dap + nvim-dap-ui + nvim-dap-go
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>db', function() require('dap').toggle_breakpoint() end, 'DAP — Toggle breakpoint')
map('n', '<leader>dB', function()
  vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(cond)
    if cond then require('dap').set_breakpoint(cond) end
  end)
end, 'DAP — Conditional breakpoint')
map('n', '<leader>dc', function() require('dap').continue() end,          'DAP — Start/continue')
map('n', '<leader>dn', function() require('dap').step_over() end,         'DAP — Step over')
map('n', '<leader>di', function() require('dap').step_into() end,         'DAP — Step into')
map('n', '<leader>do', function() require('dap').step_out() end,          'DAP — Step out')
map('n', '<leader>dr', function() require('dap').repl.toggle() end,       'DAP — Toggle REPL')
map('n', '<leader>dl', function() require('dap').run_last() end,          'DAP — Run last')
map('n', '<leader>dt', function() require('dap').terminate() end,         'DAP — Terminate')

-- UI helpers
map('n', '<leader>du', function() require('dapui').toggle() end,          'DAP UI — Toggle debugger UI')
map('n', '<leader>de', function() require('dapui').eval() end,            'DAP UI — Evaluate expression')

-- Go tests under debugger
map('n', '<leader>dgt', function() require('dap-go').debug_test() end,     'nvim-dap-go — Debug current Go test')
map('n', '<leader>dgl', function() require('dap-go').debug_last_test() end,'nvim-dap-go — Debug last Go test')

-- ──────────────────────────────────────────────────────────────────────────────
-- Bufferline
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<Tab>',     '<cmd>BufferLineCycleNext<CR>',              'Bufferline — Next buffer')
map('n', '<S-Tab>',   '<cmd>BufferLineCyclePrev<CR>',              'Bufferline — Previous buffer')
map('n', '<C-A-Left>',  '<cmd>BufferLineCyclePrev<CR>',            'Bufferline — Previous buffer (Ctrl+Opt+Left)')
map('n', '<C-A-Right>', '<cmd>BufferLineCycleNext<CR>',            'Bufferline — Next buffer (Ctrl+Opt+Right)')
map('n', '<leader>bp','<cmd>BufferLinePick<CR>',                   'Bufferline — Pick buffer by letter')
map('n', '<leader>bc','<cmd>bdelete<CR>',                          'Bufferline — Close current buffer')
map('n', '<leader>bo','<cmd>BufferLineCloseOthers<CR>',            'Bufferline — Close other buffers')
map('n', '<leader>br','<cmd>BufferLineCloseRight<CR>',             'Bufferline — Close buffers to the right')
map('n', '<leader>bl','<cmd>BufferLineCloseLeft<CR>',              'Bufferline — Close buffers to the left')
map('n', '<leader>b>', '<cmd>BufferLineMoveNext<CR>',              'Bufferline — Move buffer right')
map('n', '<leader>b<', '<cmd>BufferLineMovePrev<CR>',              'Bufferline — Move buffer left')
map('n', '<leader>bsd','<cmd>BufferLineSortByDirectory<CR>',       'Bufferline — Sort by directory')
map('n', '<leader>bse','<cmd>BufferLineSortByExtension<CR>',       'Bufferline — Sort by extension')

-- ──────────────────────────────────────────────────────────────────────────────
-- LSP extras
-- ──────────────────────────────────────────────────────────────────────────────
map('n', 'gl', vim.diagnostic.open_float,                          'LSP — Line diagnostics (float)')
map('x', '<leader>lf', function() vim.lsp.buf.format({ async=true }) end, 'LSP — Format selection (visual)')

-- ──────────────────────────────────────────────────────────────────────────────
-- Diagnostics auto-popup toggle
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>td', function()
  if vim.g._diag_toggle_func then
    vim.g._diag_toggle_func()
  end
end, 'Diagnostics — Toggle auto popup on CursorHold')

-- ──────────────────────────────────────────────────────────────────────────────
-- nvim-treesitter
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>ti', '<cmd>Inspect<CR>',                         'nvim-treesitter — Inspect highlight under cursor')
map('n', '<leader>tI', '<cmd>InspectTree<CR>',                     'nvim-treesitter — Inspect syntax tree (buffer)')
-- map('n','<leader>tp','<cmd>TSPlaygroundToggle<CR>',            'nvim-treesitter — Toggle playground')

-- ──────────────────────────────────────────────────────────────────────────────
-- Indent-blankline toggle
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>tig', '<cmd>IBLToggle<CR>', 'IBL — Toggle indent guides')

-- ──────────────────────────────────────────────────────────────────────────────
-- Vim-illuminate (navegar entre referencias)
-- ──────────────────────────────────────────────────────────────────────────────
map('n', ']]', function() require('illuminate').goto_next_reference(false) end, 'Illuminate — Next reference')
map('n', '[[', function() require('illuminate').goto_prev_reference(false) end, 'Illuminate — Previous reference')

-- ──────────────────────────────────────────────────────────────────────────────
-- Telescope extras
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>fm', function() require('telescope.builtin').marks() end,     'Telescope — Marks')
map('n', '<leader>fj', function() require('telescope.builtin').jumplist() end,  'Telescope — Jumplist')

-- ──────────────────────────────────────────────────────────────────────────────
-- Trouble quick open
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>xr', '<cmd>Trouble lsp_references<CR>',          'Trouble — LSP references (open)')
map('n', '<leader>xd0','<cmd>Trouble document_diagnostics<CR>',    'Trouble — Document diagnostics (open)')

-- ──────────────────────────────────────────────────────────────────────────────
-- DAP QoL
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>dL', function()
  vim.ui.input({ prompt = 'Logpoint message: ' }, function(msg)
    if msg then require('dap').set_breakpoint(nil, nil, msg) end
  end)
end, 'DAP — Set logpoint')
map({'n','x'}, '<leader>dv', function() require('dap.ui.widgets').hover() end, 'DAP UI — Hover eval (normal/visual)')

-- ──────────────────────────────────────────────────────────────────────────────
-- Gitsigns
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>hs', function() require('gitsigns').stage_hunk() end,        'Gitsigns — Stage hunk')
map('n', '<leader>hr', function() require('gitsigns').reset_hunk() end,        'Gitsigns — Reset hunk')
map('n', '<leader>hu', function() require('gitsigns').undo_stage_hunk() end,   'Gitsigns — Undo stage hunk')
map('n', '<leader>hS', function() require('gitsigns').stage_buffer() end,      'Gitsigns — Stage buffer')
map('n', '<leader>hR', function() require('gitsigns').reset_buffer() end,      'Gitsigns — Reset buffer')
map('n', '<leader>hp', function() require('gitsigns').preview_hunk() end,      'Gitsigns — Preview hunk')
map('n', '<leader>hb', function() require('gitsigns').toggle_current_line_blame() end,
  'Gitsigns — Toggle line blame')
map('n', ']h',        function() require('gitsigns').next_hunk() end,          'Gitsigns — Next hunk')
map('n', '[h',        function() require('gitsigns').prev_hunk() end,          'Gitsigns — Previous hunk')
map('v', '<leader>hs', function() require('gitsigns').stage_hunk({vim.fn.line('.'), vim.fn.line('v')}) end,
  'Gitsigns — Stage hunk (visual)')
map('v', '<leader>hr', function() require('gitsigns').reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end,
  'Gitsigns — Reset hunk (visual)')

-- ──────────────────────────────────────────────────────────────────────────────
-- Diffview
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>gd', '<cmd>DiffviewOpen<CR>',                        'Diffview — Open diff (vs HEAD)')
map('n', '<leader>gD', '<cmd>DiffviewClose<CR>',                       'Diffview — Close diff')
map('n', '<leader>gh', '<cmd>DiffviewFileHistory %<CR>',               'Diffview — Current file history')
map('n', '<leader>gH', '<cmd>DiffviewFileHistory<CR>',                 'Diffview — Repository file history')
map('n', '<leader>gf', '<cmd>DiffviewToggleFiles<CR>',                 'Diffview — Toggle files panel')
map('n', '<leader>gF', '<cmd>DiffviewFocusFiles<CR>',                  'Diffview — Focus files panel')

-- ──────────────────────────────────────────────────────────────────────────────
-- Spectre
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>S',  '<cmd>Spectre<CR>',                             'Spectre — Project search & replace')
map('n', '<leader>Sf', '<cmd>lua require("spectre").open_file_search()<CR>',
  'Spectre — File search & replace (current file)')
map('n', '<leader>Sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
  'Spectre — Search word under cursor')
map('x', '<leader>S',  '<esc><cmd>lua require("spectre").open_visual()<CR>',
  'Spectre — Search & replace selection')

-- ──────────────────────────────────────────────────────────────────────────────
-- Harpoon (v2)
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>ma', function() require('harpoon'):list():add() end,     'Harpoon — Add current file to list')
map('n', '<leader>mm', function()
  local ui = require('harpoon.ui')
  local harpoon = require('harpoon')
  ui.toggle_quick_menu(harpoon:list())
end, 'Harpoon — Toggle quick menu')
map('n', '<leader>mn', function() require('harpoon'):list():next() end,    'Harpoon — Next item in list')
map('n', '<leader>mp', function() require('harpoon'):list():prev() end,    'Harpoon — Previous item in list')
map('n', '<leader>m1', function() require('harpoon'):list():select(1) end, 'Harpoon — Select item 1')
map('n', '<leader>m2', function() require('harpoon'):list():select(2) end, 'Harpoon — Select item 2')
map('n', '<leader>m3', function() require('harpoon'):list():select(3) end, 'Harpoon — Select item 3')
map('n', '<leader>m4', function() require('harpoon'):list():select(4) end, 'Harpoon — Select item 4')
map('n', '<leader>m5', function() require('harpoon'):list():select(5) end, 'Harpoon — Select item 5')

-- ──────────────────────────────────────────────────────────────────────────────
-- Claude Code (replaces Copilot section)
-- ──────────────────────────────────────────────────────────────────────────────
-- <leader>a group is defined in which-key (lazy.lua)
map('n', '<leader>ac', '<cmd>ClaudeCode<cr>',                   'Claude — Toggle panel')
map('n', '<leader>af', '<cmd>ClaudeCodeFocus<cr>',              'Claude — Focus/toggle')
map('n', '<leader>ar', '<cmd>ClaudeCode --resume<cr>',          'Claude — Resume session')
map('n', '<leader>aC', '<cmd>ClaudeCode --continue<cr>',        'Claude — Continue')
map('n', '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>',        'Claude — Select model')
map('n', '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>',              'Claude — Add current buffer')
map('v', '<leader>as', '<cmd>ClaudeCodeSend<cr>',               'Claude — Send visual selection')
map('n', '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>',         'Claude — Accept diff')
map('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>',           'Claude — Deny diff')

-- In file explorers, <leader>as adds file instead of sending selection
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
  callback = function(ev)
    map('n', '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', 'Claude — Add file (explorer)')
  end,
})

-- ──────────────────────────────────────────────────────────────────────────────
-- NvimTree buffer-specific keymaps
-- ──────────────────────────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'NvimTree',
  callback = function(ev)
    local api = require('nvim-tree.api')
    local bufnr = ev.buf

    local function bufmap(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = 'nvim-tree: ' .. desc })
    end

    -- Open actions
    bufmap('n', '<CR>', api.node.open.edit, 'Open')
    bufmap('n', 'o', api.node.open.edit, 'Open')
    bufmap('n', 'i', api.node.open.horizontal, 'Open: Horizontal Split')
    bufmap('n', 's', api.node.open.vertical, 'Open: Vertical Split')
    bufmap('n', 't', api.node.open.tab, 'Open: New Tab')
    bufmap('n', 'v', api.node.open.vertical, 'Open: Vertical Split')
    bufmap('n', '<C-v>', api.node.open.vertical, 'Open: Vertical Split')
    bufmap('n', '<C-x>', api.node.open.horizontal, 'Open: Horizontal Split')
    bufmap('n', '<C-t>', api.node.open.tab, 'Open: New Tab')

    -- Navigation
    bufmap('n', '<', api.node.navigate.sibling.prev, 'Previous Sibling')
    bufmap('n', '>', api.node.navigate.sibling.next, 'Next Sibling')
    bufmap('n', 'P', api.node.navigate.parent, 'Parent Directory')
    bufmap('n', '<BS>', api.node.navigate.parent_close, 'Close Directory')
    bufmap('n', '<Tab>', api.node.open.preview, 'Open Preview')
    bufmap('n', 'K', api.node.navigate.sibling.first, 'First Sibling')
    bufmap('n', 'J', api.node.navigate.sibling.last, 'Last Sibling')

    -- Toggles
    bufmap('n', 'I', api.tree.toggle_gitignore_filter, 'Toggle Git Ignore')
    bufmap('n', 'H', api.tree.toggle_hidden_filter, 'Toggle Dotfiles')
    bufmap('n', 'R', api.tree.reload, 'Refresh')

    -- File operations
    bufmap('n', 'a', api.fs.create, 'Create')
    bufmap('n', 'd', api.fs.remove, 'Delete')
    bufmap('n', 'D', api.fs.trash, 'Trash')
    bufmap('n', 'r', api.fs.rename, 'Rename')
    bufmap('n', '<C-r>', api.fs.rename_sub, 'Rename: Omit Filename')
    bufmap('n', 'x', api.fs.cut, 'Cut')
    bufmap('n', 'c', api.fs.copy.node, 'Copy')
    bufmap('n', 'p', api.fs.paste, 'Paste')

    -- Copy paths
    bufmap('n', 'y', api.fs.copy.filename, 'Copy Name')
    bufmap('n', 'Y', api.fs.copy.relative_path, 'Copy Relative Path')
    bufmap('n', 'gy', api.fs.copy.absolute_path, 'Copy Absolute Path')

    -- Git navigation
    bufmap('n', '[c', api.node.navigate.git.prev, 'Prev Git')
    bufmap('n', ']c', api.node.navigate.git.next, 'Next Git')

    -- Tree operations
    bufmap('n', '-', api.tree.change_root_to_parent, 'Up')
    bufmap('n', 'q', api.tree.close, 'Close')
    bufmap('n', 'g?', api.tree.toggle_help, 'Help')
  end,
})

-- ──────────────────────────────────────────────────────────────────────────────
-- Terminal
-- ──────────────────────────────────────────────────────────────────────────────
local function toggle_bottom_term()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == 'terminal' then
      vim.api.nvim_win_close(win, false)
      return
    end
  end
  vim.cmd('botright split | resize 12 | terminal')
  vim.cmd('startinsert')
end
map('n', '<leader>T', toggle_bottom_term, 'Terminal — Toggle bottom console (native)')

-- ──────────────────────────────────────────────────────────────────────────────
-- Soft-wrap utilities
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>tw', function()
  local w = vim.wo
  w.wrap = not w.wrap
  w.linebreak = w.wrap
  w.breakindent = w.wrap
  w.showbreak = w.wrap and '↳ ' or ''
  w.breakindentopt = 'shift:2,sbr'
end, 'Toggle soft-wrap (visual)')

local function SoftWrapAt(cols)
  vim.wo.wrap = true
  vim.wo.linebreak = true
  vim.wo.breakindent = true
  vim.wo.showbreak = '↳ '
  vim.wo.breakindentopt = 'shift:2,sbr'
  vim.cmd('vertical resize ' .. tonumber(cols))
end

map('n', '<leader>w8', function() SoftWrapAt(80) end,  'Soft-wrap at 80 cols')
map('n', '<leader>w0', function() SoftWrapAt(100) end, 'Soft-wrap at 100 cols')
map('n', '<leader>w2', function() SoftWrapAt(120) end, 'Soft-wrap at 120 cols')

-- ──────────────────────────────────────────────────────────────────────────────
-- Comment
-- ──────────────────────────────────────────────────────────────────────────────
local api = require("Comment.api")
map("n", "<leader>/", api.toggle.linewise.current, "Comment — Toggle current line")
map("x", "<leader>/", function()
  api.toggle.linewise(vim.fn.visualmode())
end, "Comment — Toggle selection")

map("n", "gcc", api.toggle.linewise.current, "Comment — Toggle current line")
map("n", "gbc", api.toggle.blockwise.current, "Comment — Toggle current block")

map("x", "gc", function() api.toggle.linewise(vim.fn.visualmode()) end, "Comment — Toggle selection (line)")
map("x", "gb", function() api.toggle.blockwise(vim.fn.visualmode()) end, "Comment — Toggle selection (block)")

set("n", "gc", function()
  return api.call("toggle.linewise", "g@")
end, { expr = true, silent = true, desc = "Comment — Operator (line)" })

set("n", "gb", function()
  return api.call("toggle.blockwise", "g@")
end, { expr = true, silent = true, desc = "Comment — Operator (block)" })

map("n", "gco", api.insert.linewise.below, "Comment — Insert below")
map("n", "gcO", api.insert.linewise.above, "Comment — Insert above")
map("n", "gcA", api.insert.linewise.eol,   "Comment — Comment at EOL")

-- ──────────────────────────────────────────────────────────────────────────────
-- Flash.nvim (navegación rápida)
-- ──────────────────────────────────────────────────────────────────────────────
map({'n', 'x', 'o'}, 's', function() require("flash").jump() end, 'Flash — Jump to location')
map({'n', 'x', 'o'}, 'S', function() require("flash").treesitter() end, 'Flash — Treesitter select')
map('o', 'r', function() require("flash").remote() end, 'Flash — Remote operation')
map({'o', 'x'}, 'R', function() require("flash").treesitter_search() end, 'Flash — Treesitter search')
map('c', '<c-s>', function() require("flash").toggle() end, 'Flash — Toggle search')

-- ──────────────────────────────────────────────────────────────────────────────
-- Todo-comments
-- ──────────────────────────────────────────────────────────────────────────────
map('n', ']t', function() require("todo-comments").jump_next() end, 'Todo — Next todo comment')
map('n', '[t', function() require("todo-comments").jump_prev() end, 'Todo — Previous todo comment')
map('n', '<leader>ft', '<cmd>TodoTelescope<cr>', 'Telescope — Todo comments')
map('n', '<leader>fT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>', 'Telescope — Todo/Fix/Fixme')

-- ──────────────────────────────────────────────────────────────────────────────
-- Persistence (sesiones)
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>qs', function() require("persistence").load() end, 'Session — Restore current dir session')
map('n', '<leader>ql', function() require("persistence").load({ last = true }) end, 'Session — Restore last session')
map('n', '<leader>qd', function() require("persistence").stop() end, 'Session — Don\'t save current session')

-- ──────────────────────────────────────────────────────────────────────────────
-- Go.nvim
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>goj', '<cmd>GoTagAdd json<cr>', 'Go — Add json tags')
map('n', '<leader>goy', '<cmd>GoTagAdd yaml<cr>', 'Go — Add yaml tags')
map('n', '<leader>goe', '<cmd>GoIfErr<cr>', 'Go — Add if err')
map('n', '<leader>got', '<cmd>GoTestFunc<cr>', 'Go — Test function')
map('n', '<leader>goT', '<cmd>GoTestFile<cr>', 'Go — Test file')
map('n', '<leader>goa', '<cmd>GoTestPkg<cr>', 'Go — Test package')
map('n', '<leader>goc', '<cmd>GoCoverage<cr>', 'Go — Coverage')
map('n', '<leader>goi', '<cmd>GoImpl<cr>', 'Go — Implement interface')
map('n', '<leader>gof', '<cmd>GoFillStruct<cr>', 'Go — Fill struct')
map('n', '<leader>gos', '<cmd>GoFillSwitch<cr>', 'Go — Fill switch')

-- Organize imports manually
map('n', '<leader>goo', function()
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)

  local found = false
  for _, res in pairs(result or {}) do
    for _, action in pairs(res.result or {}) do
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, "utf-16")
        found = true
      end
      if action.command then
        vim.lsp.buf.execute_command(action.command)
        found = true
      end
    end
  end

  if found then
    print("✅ Imports organized")
  else
    print("⚠️  No imports found to organize")
  end
end, 'Go — Organize imports')

-- Quick fix to add imports (when there's an error)
map('n', '<leader>goq', function()
  local params = vim.lsp.util.make_range_params()
  params.context = {
    diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
    only = { "quickfix" }
  }
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)

  if not result or vim.tbl_isempty(result) then
    print("⚠️  No hay quick fixes disponibles")
    return
  end

  for _, res in pairs(result) do
    for _, action in pairs(res.result or {}) do
      -- Busca acciones que añadan imports
      if action.title and (action.title:match("Add import") or action.title:match("import")) then
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, "utf-16")
        end
        if action.command then
          vim.lsp.buf.execute_command(action.command)
        end
        print("✅ " .. action.title)
        return
      end
    end
  end

  print("ℹ️  No se encontró 'Add import'. Usa ,la para ver todas las opciones")
end, 'Go — Quick fix (add import)')

-- Go debug: busca main.go en el proyecto y permite elegir cuál debugear
map('n', '<leader>god', function()
  local dap = require('dap')
  local root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]

  if not root or root == '' then
    root = vim.fn.getcwd()
  end

  -- Configura dap para Go si no está configurado
  if not dap.configurations.go then
    require('dap-go').setup()
  end

  -- Busca todos los main.go en el proyecto
  local main_files = vim.fn.systemlist('find ' .. vim.fn.shellescape(root) .. ' -type f -name "main.go" 2>/dev/null')

  if #main_files == 0 then
    print('No main.go found in project')
    return
  end

  -- Función para iniciar el debug
  local function start_debug(main_path)
    local dir = vim.fn.fnamemodify(main_path, ':h')

    -- Carga variables de entorno desde .env.local si existe
    local env_vars = {}
    local env_file = root .. '/.env.local'
    if vim.fn.filereadable(env_file) == 1 then
      for line in io.lines(env_file) do
        local key, value = line:match('^([^=]+)=(.*)$')
        if key and value then
          value = value:gsub('^"(.*)"$', '%1'):gsub("^'(.*)'$", '%1')
          env_vars[key] = value
        end
      end
      print('Loaded env from: ' .. env_file)
    end

    -- Configuración para debugear
    dap.run({
      type = 'go',
      name = 'Debug ' .. vim.fn.fnamemodify(main_path, ':h:t'),
      request = 'launch',
      mode = 'debug',
      program = dir,
      cwd = dir,
      env = env_vars,
    })

    require('dapui').open()
    print('Debugging: ' .. main_path)
  end

  -- Si solo hay un main.go, úsalo directamente
  if #main_files == 1 then
    start_debug(main_files[1])
    return
  end

  -- Si hay múltiples, siempre muestra selector
  local options = {}
  for _, path in ipairs(main_files) do
    local relative_path = (path:gsub(root .. '/', ''))
    table.insert(options, relative_path)
  end

  vim.ui.select(options, {
    prompt = 'Select main.go to debug:',
    format_item = function(item)
      return item
    end,
  }, function(choice, idx)
    if choice then
      start_debug(main_files[idx])
    end
  end)
end, 'Go — Debug (smart main.go finder)')

-- Go run: busca main.go en el proyecto y permite elegir cuál ejecutar
map('n', '<leader>gor', function()
  local root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]

  if not root or root == '' then
    root = vim.fn.getcwd()
  end

  -- Busca todos los main.go en el proyecto
  local main_files = vim.fn.systemlist('find ' .. vim.fn.shellescape(root) .. ' -type f -name "main.go" 2>/dev/null')

  if #main_files == 0 then
    print('No main.go found in project')
    return
  end

  -- Función para ejecutar go run
  local function run_main(main_path)
    local dir = vim.fn.fnamemodify(main_path, ':h')
    local env_file = root .. '/.env.local'
    local env_cmd = vim.fn.filereadable(env_file) == 1 and ('set -a && source ' .. vim.fn.shellescape(env_file) .. ' && set +a && ') or ''

    -- Encuentra el siguiente ID de terminal disponible
    local Terminal = require('toggleterm.terminal').Terminal
    local term_count = vim.fn.len(require('toggleterm.terminal').get_all())
    local next_id = term_count + 1

    -- Crea un nuevo terminal con un ID único
    local go_term = Terminal:new({
      cmd = env_cmd .. 'cd ' .. vim.fn.shellescape(dir) .. ' && go run .',
      direction = 'horizontal',
      close_on_exit = false,
      count = next_id,
      on_exit = function(_, _, exit_code)
        if exit_code == 0 then
          print('Go run [' .. next_id .. '] finished successfully')
        else
          print('Go run [' .. next_id .. '] exited with code ' .. exit_code)
        end
      end,
    })

    go_term:toggle()
    print('Terminal ' .. next_id .. ' running: ' .. main_path)
  end

  -- Si solo hay un main.go, úsalo directamente
  if #main_files == 1 then
    run_main(main_files[1])
    return
  end

  -- Si hay múltiples, siempre muestra selector
  local options = {}
  for _, path in ipairs(main_files) do
    local relative_path = (path:gsub(root .. '/', ''))
    table.insert(options, relative_path)
  end

  vim.ui.select(options, {
    prompt = 'Select main.go to run:',
    format_item = function(item)
      return item
    end,
  }, function(choice, idx)
    if choice then
      run_main(main_files[idx])
    end
  end)
end, 'Go — Run (smart main.go finder)')

map('n', '<leader>gob', function()
  local dir = vim.fn.expand('%:p:h')  -- Current file directory
  vim.cmd('!cd ' .. vim.fn.shellescape(dir) .. ' && go build .')
end, 'Go — Build current directory')

-- Go mod & dependencies
map('n', '<leader>gmt', '<cmd>!go mod tidy<CR>', 'Go — Mod tidy')
map('n', '<leader>gmv', '<cmd>!go mod vendor<CR>', 'Go — Mod vendor')
map('n', '<leader>gmd', '<cmd>!go mod download<CR>', 'Go — Mod download')

-- Go get/install
map('n', '<leader>ggi', function()
  vim.ui.input({ prompt = 'go get: ' }, function(input)
    if input then
      vim.cmd('!go get ' .. input)
    end
  end)
end, 'Go — Get package')

-- All tags operations (using capital letters to avoid collision)
map('n', '<leader>goA', function()
  vim.cmd('GoTagAdd json')
  vim.cmd('GoTagAdd yaml')
end, 'Go — Add json & yaml tags')

map('n', '<leader>goR', '<cmd>GoTagRm<CR>', 'Go — Remove all tags')

-- Test shortcuts
map('n', '<leader>gol', '<cmd>GoTestLast<CR>', 'Go — Test last')

-- Generate
map('n', '<leader>gg', '<cmd>!go generate ./...<CR>', 'Go — Generate')

-- Mod init
map('n', '<leader>gmi', function()
  vim.ui.input({ prompt = 'Module name: ' }, function(input)
    if input then
      vim.cmd('!go mod init ' .. input)
    end
  end)
end, 'Go — Mod init')

-- ──────────────────────────────────────────────────────────────────────────────
-- Terminal toggleterm navigation
-- ──────────────────────────────────────────────────────────────────────────────
-- Abre/cierra el último terminal con Ctrl+\
map({'n', 't'}, '<C-\\>', '<cmd>ToggleTerm<cr>', 'Terminal — Toggle last terminal')

-- Acceso rápido a terminales numerados con <leader>t1, <leader>t2, etc.
for i = 1, 9 do
  map({'n', 't'}, '<leader>t' .. i, '<cmd>' .. i .. 'ToggleTerm<cr>', 'Terminal — Toggle terminal ' .. i)
end

-- Navega al siguiente/anterior terminal (usando send para cambiar)
map('t', '<C-PageDown>', function()
  local terms = require('toggleterm.terminal').get_all()
  if #terms > 1 then
    vim.cmd('ToggleTerm')
    vim.defer_fn(function() vim.cmd((vim.v.count > 0 and vim.v.count or 2) .. 'ToggleTerm') end, 50)
  end
end, 'Terminal — Next terminal')
map('t', '<C-PageUp>', function()
  local terms = require('toggleterm.terminal').get_all()
  if #terms > 1 then
    vim.cmd('ToggleTerm')
    vim.defer_fn(function() vim.cmd('1ToggleTerm') end, 50)
  end
end, 'Terminal — Previous terminal')

-- Cierra todos los terminales
map('n', '<leader>tq', '<cmd>ToggleTermToggleAll<cr>', 'Terminal — Close all terminals')

-- ──────────────────────────────────────────────────────────────────────────────
-- Better window navigation
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<C-h>', '<C-w>h', 'Window — Move to left window')
map('n', '<C-j>', '<C-w>j', 'Window — Move to bottom window')
map('n', '<C-k>', '<C-w>k', 'Window — Move to top window')
map('n', '<C-l>', '<C-w>l', 'Window — Move to right window')

-- Terminal mode window navigation
map('t', '<C-h>', '<C-\\><C-n><C-w>h', 'Window — Move to left window (terminal)')
map('t', '<C-j>', '<C-\\><C-n><C-w>j', 'Window — Move to bottom window (terminal)')
map('t', '<C-k>', '<C-\\><C-n><C-w>k', 'Window — Move to top window (terminal)')
map('t', '<C-l>', '<C-\\><C-n><C-w>l', 'Window — Move to right window (terminal)')

-- ESC to exit terminal mode
map('t', '<Esc>', '<C-\\><C-n>', 'Exit terminal mode')

-- Ctrl+w + flechas (navegación alternativa)
map('n', '<C-w><Left>', '<C-w>h', 'Window — Move to left window')
map('n', '<C-w><Down>', '<C-w>j', 'Window — Move to bottom window')
map('n', '<C-w><Up>', '<C-w>k', 'Window — Move to top window')
map('n', '<C-w><Right>', '<C-w>l', 'Window — Move to right window')

-- ──────────────────────────────────────────────────────────────────────────────
-- Better window resizing
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<C-Up>', '<cmd>resize +2<CR>', 'Window — Increase height')
map('n', '<C-Down>', '<cmd>resize -2<CR>', 'Window — Decrease height')
map('n', '<C-Left>', '<cmd>vertical resize -2<CR>', 'Window — Decrease width')
map('n', '<C-Right>', '<cmd>vertical resize +2<CR>', 'Window — Increase width')

-- ──────────────────────────────────────────────────────────────────────────────
-- Better paste (no yank on paste in visual mode)
-- ──────────────────────────────────────────────────────────────────────────────
map('x', 'p', '"_dP', 'Paste — Without yanking replaced text')

-- ──────────────────────────────────────────────────────────────────────────────
-- Better indenting (keep selection after indent)
-- ──────────────────────────────────────────────────────────────────────────────
map('v', '<', '<gv', 'Indent — Decrease and keep selection')
map('v', '>', '>gv', 'Indent — Increase and keep selection')

-- ──────────────────────────────────────────────────────────────────────────────
-- Move lines up/down
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<A-j>', '<cmd>m .+1<CR>==', 'Move — Line down')
map('n', '<A-k>', '<cmd>m .-2<CR>==', 'Move — Line up')
map('v', '<A-j>', ":m '>+1<CR>gv=gv", 'Move — Selection down')
map('v', '<A-k>', ":m '<-2<CR>gv=gv", 'Move — Selection up')

-- ──────────────────────────────────────────────────────────────────────────────
-- Clear search highlight
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<Esc>', '<cmd>nohlsearch<CR>', 'Clear search highlight')

-- ──────────────────────────────────────────────────────────────────────────────
-- Quick save
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<C-s>', '<cmd>w<CR>', 'Save file')
map('i', '<C-s>', '<Esc><cmd>w<CR>a', 'Save file (insert mode)')

-- ──────────────────────────────────────────────────────────────────────────────
-- LSP shortcuts (faster, no leader)
-- ──────────────────────────────────────────────────────────────────────────────
map('n', 'K', vim.lsp.buf.hover, 'LSP — Hover documentation')
map('n', 'gd', vim.lsp.buf.definition, 'LSP — Go to definition')
map('n', 'gD', vim.lsp.buf.declaration, 'LSP — Go to declaration')
map('n', 'gr', vim.lsp.buf.references, 'LSP — References')
map('n', 'gi', vim.lsp.buf.implementation, 'LSP — Go to implementation')
map('n', 'gt', vim.lsp.buf.type_definition, 'LSP — Go to type definition')

-- Ctrl+Click → go to definition
set('n', '<C-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>',
  { noremap = true, silent = true, desc = 'LSP — Ctrl+Click go to definition' })

-- ──────────────────────────────────────────────────────────────────────────────
-- Quickfix & Location list navigation
-- ──────────────────────────────────────────────────────────────────────────────
map('n', ']q', '<cmd>cnext<CR>', 'Quickfix — Next item')
map('n', '[q', '<cmd>cprev<CR>', 'Quickfix — Previous item')
map('n', ']l', '<cmd>lnext<CR>', 'Location — Next item')
map('n', '[l', '<cmd>lprev<CR>', 'Location — Previous item')
map('n', '<leader>co', '<cmd>copen<CR>', 'Quickfix — Open')
map('n', '<leader>cc', '<cmd>cclose<CR>', 'Quickfix — Close')
map('n', '<leader>Lo', '<cmd>lopen<CR>', 'Location — Open (capital L)')
map('n', '<leader>Lc', '<cmd>lclose<CR>', 'Location — Close (capital L)')

-- ──────────────────────────────────────────────────────────────────────────────
-- Window/Split management
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>sv', '<cmd>vsplit<CR>', 'Window — Split vertical')
map('n', '<leader>sh', '<cmd>split<CR>', 'Window — Split horizontal')
map('n', '<leader>sx', '<cmd>close<CR>', 'Window — Close split')
map('n', '<leader>so', '<cmd>only<CR>', 'Window — Close all others')
map('n', '<leader>se', '<C-w>=', 'Window — Equal size')
map('n', '<leader>sm', function()
  if vim.t.maximized then
    vim.cmd('wincmd =')
    vim.t.maximized = false
  else
    vim.cmd('wincmd |')
    vim.cmd('wincmd _')
    vim.t.maximized = true
  end
end, 'Window — Maximize toggle')

-- ──────────────────────────────────────────────────────────────────────────────
-- Quick quit
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>q', '<cmd>q<CR>', 'Quit window')
map('n', '<leader>Q', '<cmd>qa<CR>', 'Quit all')

-- ──────────────────────────────────────────────────────────────────────────────
-- Toggle options
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>un', function()
  vim.wo.number = not vim.wo.number
  print('Line numbers: ' .. (vim.wo.number and 'ON' or 'OFF'))
end, 'Toggle — Line numbers')

map('n', '<leader>ur', function()
  vim.wo.relativenumber = not vim.wo.relativenumber
  print('Relative numbers: ' .. (vim.wo.relativenumber and 'ON' or 'OFF'))
end, 'Toggle — Relative numbers')

map('n', '<leader>us', function()
  vim.wo.spell = not vim.wo.spell
  print('Spell check: ' .. (vim.wo.spell and 'ON' or 'OFF'))
end, 'Toggle — Spell check')

map('n', '<leader>uw', function()
  vim.wo.wrap = not vim.wo.wrap
  print('Wrap: ' .. (vim.wo.wrap and 'ON' or 'OFF'))
end, 'Toggle — Wrap')

-- ──────────────────────────────────────────────────────────────────────────────
-- New file
-- ──────────────────────────────────────────────────────────────────────────────
map('n', '<leader>n', '<cmd>enew<CR>', 'New buffer')

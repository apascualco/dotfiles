local set = vim.keymap.set
local function map(mode, lhs, rhs, desc)
  set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

local function go_test_env(path)
  local ok, env = pcall(require('apascualco.goproject').test_env, path)
  if ok then return env end
end

local function neotest_run(path, args)
  args = require('apascualco.goproject').neotest_args(path, args)
  if args then require('neotest').run.run(args) end
end

map('n', '<leader>e',  '<cmd>NvimTreeToggle<CR>',   'File explorer')
map('n', '<leader>Ef', '<cmd>NvimTreeFocus<CR>',    'Focus explorer')
map('n', '<leader>Ee', '<cmd>NvimTreeFindFile<CR>', 'Reveal current file')
map('n', '<leader>Ec', '<cmd>NvimTreeCollapse<CR>', 'Collapse all')
map('n', '<leader>Er', '<cmd>NvimTreeRefresh<CR>',  'Refresh')

map('n', '<leader>ff', function() require('telescope.builtin').find_files() end, 'Find files')
map('n', '<leader>fF', function() require('telescope.builtin').find_files({ no_ignore = true, hidden = true }) end,
  'Find all files (hidden + ignored)')
map('n', '<leader>fg', function() require('telescope.builtin').live_grep() end,  'Grep in project')
map('n', '<leader>fs', function() require('telescope.builtin').grep_string() end,'Grep word under cursor')
map('n', '<leader>f/', function() require('telescope.builtin').current_buffer_fuzzy_find() end,
  'Search in buffer')
map('n', '<leader>fb', function() require('telescope.builtin').buffers() end,    'Buffers')
map('n', '<leader>fB', function() require('telescope.builtin').git_branches({ show_remote_tracking_branches = false }) end, 'Local branches')
map('n', '<leader>fS', function() require('telescope.builtin').git_stash() end, 'Git stashes')
map('n', '<leader>fo', function() require('telescope.builtin').oldfiles() end,   'Recent files')
map('n', '<leader>fh', function() require('telescope.builtin').help_tags() end,  'Help')
map('n', '<leader>fk', function() require('telescope.builtin').keymaps() end,    'Keymaps')
map('n', '<leader>fc', function() require('telescope.builtin').commands() end,   'Commands')
map('n', '<leader>f:', function() require('telescope.builtin').command_history() end, 'Command history')
map('n', '<leader>f?', function() require('telescope.builtin').search_history() end,  'Search history')
map('n', '<leader>fr', function() require('telescope.builtin').resume() end,     'Resume last search')
map('n', '<leader>f"', function() require('telescope.builtin').registers() end, 'Registers')

map('n', '<leader>fR', function() require('apascualco.gomain').run() end, 'Run main.go')

map('n', '<leader>gn', '<cmd>Neogit<CR>',                                           'Neogit')

map('n', '<leader>gs', function() require('telescope.builtin').git_status() end,    'Status')
map('n', '<leader>gb', function() require('telescope.builtin').git_branches() end,  'Branches')
map('n', '<leader>gc', function() require('telescope.builtin').git_commits() end,   'Commits (repo)')
map('n', '<leader>gC', function() require('telescope.builtin').git_bcommits() end,  'Commits (this file)')

map('n', '<leader>lr', function() require('telescope.builtin').lsp_references() end,          'References')
map('n', '<leader>li', function() require('telescope.builtin').lsp_implementations() end,     'Implementations')
map('n', '<leader>ls', function() require('telescope.builtin').lsp_document_symbols() end,    'Document symbols')
map('n', '<leader>lS', function() require('telescope.builtin').lsp_workspace_symbols() end,   'Workspace symbols')
map('n', '<leader>dd', function() require('telescope.builtin').diagnostics() end,             'Search diagnostics')
map('n', '<leader>lh', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, 'Toggle inlay hints')

map('n', '<leader>ss', function() require('telescope').extensions.luasnip.luasnip() end,
  'Snippets')
map('n', '<leader>fn', function() Snacks.notifier.show_history() end,
  'Notifications')

map('n', '<leader>tt', '<cmd>TagbarToggle<CR>', 'Toggle outline')
map('n', '<leader>to', '<cmd>TagbarOpen<CR>',   'Open outline')

map('n', '<leader>lI', '<cmd>checkhealth vim.lsp<CR>',          'LSP status')
map('n', '<leader>lm', '<cmd>Mason<CR>',                         'Mason')
map('n', '<leader>la', vim.lsp.buf.code_action,                  'Code actions')
map('n', '<leader>lR', vim.lsp.buf.rename,                       'Rename symbol')
map('n', '<leader>lD', vim.lsp.buf.declaration,                  'Go to declaration')
map('n', '<leader>ld', vim.lsp.buf.definition,                   'Go to definition')
map('n', '<leader>lt', vim.lsp.buf.type_definition,              'Go to type definition')
map('n', '<leader>lK', vim.lsp.buf.signature_help,               'Signature help')
map('n', '<leader>lf', function() vim.lsp.buf.format({ async = true }) end, 'Format with LSP')
map('n', '<leader>le', vim.diagnostic.open_float,                'Diagnostic at cursor')
map('n', '<leader>lq', vim.diagnostic.setloclist,                'Diagnostics to location list')
map('x', '<leader>la', function() vim.lsp.buf.code_action() end, 'Code actions')
map('n', '<leader>lc', vim.lsp.codelens.run,                     'Run code lens')
map('n', '<leader>lx', function()
  local names = vim.tbl_map(function(c) return c.name end, vim.lsp.get_configs({ enabled = true }))
  vim.lsp.enable(names)
end, 'Reattach LSP')

map('i', '<C-Space>', '<cmd>lua require("cmp").complete()<CR>',          'Trigger completion')
map('i', '<C-y>',     '<cmd>lua require("cmp").confirm({ select = true })<CR>',
  'Confirm completion')
map('i', '<C-e>',     '<cmd>lua require("cmp").abort()<CR>',             'Abort completion')
map({'i','s'}, '<C-j>', function() require('luasnip').jump(1) end,       'Next snippet field')
map({'i','s'}, '<C-k>', function() require('luasnip').jump(-1) end,      'Previous snippet field')

map('n', '<leader>ll', function() require('lint').try_lint() end,        'Run linter')

map('n', '<leader>cf', function() require('conform').format({ async = true, lsp_fallback = true }) end,
  'Format file')

map('n', '<leader>xx',  '<cmd>Trouble diagnostics toggle<CR>',                    'Workspace diagnostics')
map('n', '<leader>xd',  '<cmd>Trouble diagnostics toggle filter.buf=0<CR>',       'Buffer diagnostics')
map('n', '<leader>xl',  '<cmd>Trouble loclist toggle<CR>',                        'Location list')
map('n', '<leader>xq',  '<cmd>Trouble qflist toggle<CR>',                         'Quickfix list')
map('n', '<leader>xs',  '<cmd>Trouble symbols toggle focus=false<CR>',            'Document symbols')
map('n', '<leader>xL',  '<cmd>Trouble lsp toggle focus=false<CR>',                'LSP panel')

map('n', '<leader>db', function() require('dap').toggle_breakpoint() end, 'Toggle breakpoint')
map('n', '<leader>dB', function()
  vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(cond)
    if cond then require('dap').set_breakpoint(cond) end
  end)
end, 'Conditional breakpoint')
map('n', '<leader>dc', function() require('dap').continue() end,          'Start / continue')
map('n', '<leader>dn', function() require('dap').step_over() end,         'Step over')
map('n', '<leader>di', function() require('dap').step_into() end,         'Step into')
map('n', '<leader>do', function() require('dap').step_out() end,          'Step out')
map('n', '<leader>dr', function() require('dap').repl.toggle() end,       'Toggle REPL')
map('n', '<leader>dl', function() require('dap').run_last() end,          'Rerun last')
map('n', '<leader>dt', function()
  require('dap').terminate()
  require('dapui').close()
end, 'Stop and close UI')

map('n', '<leader>du', function() require('dapui').toggle() end,          'Toggle UI')
map('n', '<leader>de', function() require('dapui').eval() end,            'Evaluate expression')

map('n', '<leader>dgt', function()
  local path = vim.api.nvim_buf_get_name(0)
  local env = go_test_env(path)
  if not env then return end
  local config = { buildFlags = require('apascualco.goproject').build_flags(path) }
  if next(env) then config.env = env end
  require('dap-go').debug_test(config)
end, 'Test at cursor')
map('n', '<leader>dgl', function()
  local dapgo = require('dap-go')
  if not dapgo.last_testname or dapgo.last_testname == '' then
    vim.notify('No last Go test to debug', vim.log.levels.WARN)
    return
  end
  local env = go_test_env(dapgo.last_testpath)
  if not env then return end
  require('dap').run({
    type = 'go',
    name = dapgo.last_testname,
    request = 'launch',
    mode = 'test',
    program = dapgo.last_testpath,
    args = { '-test.run', '^' .. dapgo.last_testname .. '$' },
    buildFlags = require('apascualco.goproject').build_flags(dapgo.last_testpath) or dapgo.test_buildflags,
    outputMode = 'remote',
    env = next(env) and env or nil,
  })
end, 'Last test')

map('n', '<leader>dpt', function() require('dap-python').test_method() end, 'Test method')
map('n', '<leader>dpc', function() require('dap-python').test_class() end,  'Test class')
map('x', '<leader>dps', function() require('dap-python').debug_selection() end, 'Selection')

map('n', '<leader>dR', function() require('apascualco.gomain').debug() end, 'Debug main.go')

map('n', '<Tab>',     '<cmd>BufferLineCycleNext<CR>',              'Next buffer')
map('n', '<S-Tab>',   '<cmd>BufferLineCyclePrev<CR>',              'Previous buffer')
map('n', '<C-A-Left>',  '<cmd>BufferLineCyclePrev<CR>',            'Previous buffer')
map('n', '<C-A-Right>', '<cmd>BufferLineCycleNext<CR>',            'Next buffer')
map('n', '<leader>bp','<cmd>BufferLinePick<CR>',                   'Pick buffer')
map('n', '<leader>bc','<cmd>bdelete<CR>',                          'Close buffer')
map('n', '<leader>bo','<cmd>BufferLineCloseOthers<CR>',            'Close others')
map('n', '<leader>br','<cmd>BufferLineCloseRight<CR>',             'Close all to the right')
map('n', '<leader>bl','<cmd>BufferLineCloseLeft<CR>',              'Close all to the left')
map('n', '<leader>b>', '<cmd>BufferLineMoveNext<CR>',              'Move right')
map('n', '<leader>b<', '<cmd>BufferLineMovePrev<CR>',              'Move left')
map('n', '<leader>bsd','<cmd>BufferLineSortByDirectory<CR>',       'By directory')
map('n', '<leader>bse','<cmd>BufferLineSortByExtension<CR>',       'By extension')

map('n', 'gl', vim.diagnostic.open_float,                          'Line diagnostics')
map('x', '<leader>lf', function() vim.lsp.buf.format({ async=true }) end, 'Format selection')

map('n', '<leader>td', function() require('tiny-inline-diagnostic').toggle() end,
  'Toggle inline diagnostics')

map('n', '<leader>ti', '<cmd>Inspect<CR>',                         'Inspect highlight')
map('n', '<leader>tI', '<cmd>InspectTree<CR>',                     'Inspect syntax tree')

map('n', '<leader>ui', '<cmd>IBLToggle<CR>', 'Indent guides')

map('n', ']]', function() Snacks.words.jump(vim.v.count1) end,  'Next reference')
map('n', '[[', function() Snacks.words.jump(-vim.v.count1) end, 'Previous reference')

map('n', '<leader>fw', function()
  local word = vim.fn.expand('<cword>')
  require('telescope.builtin').current_buffer_fuzzy_find({ default_text = word })
end, 'Word under cursor in buffer')
map('n', '<leader>fm', function() require('telescope.builtin').marks() end,     'Marks')
map('n', '<leader>fj', function() require('telescope.builtin').jumplist() end,  'Jump list')

map('n', '<leader>xr', '<cmd>Trouble lsp_references<CR>',          'LSP references')

map('n', '<leader>dL', function()
  vim.ui.input({ prompt = 'Logpoint message: ' }, function(msg)
    if msg then require('dap').set_breakpoint(nil, nil, msg) end
  end)
end, 'Logpoint')
map({'n','x'}, '<leader>dv', function() require('dap.ui.widgets').hover() end, 'Inspect value')

map('n', '<leader>ji', '<cmd>MoltenInit<cr>',                  'Start kernel')
map('n', '<leader>jl', '<cmd>MoltenEvaluateLine<cr>',          'Run line')
map('n', '<leader>jc', '<cmd>MoltenReevaluateCell<cr>',        'Re-run cell')
map('n', '<leader>jr', '<cmd>MoltenEvaluateOperator<cr>',      'Run (operator)')
map('x', '<leader>jv', ':<C-u>MoltenEvaluateVisual<cr>gv',     'Run selection')
map('n', '<leader>jo', '<cmd>MoltenShowOutput<cr>',            'Show output')
map('n', '<leader>jh', '<cmd>MoltenHideOutput<cr>',            'Hide output')
map('n', '<leader>jd', '<cmd>MoltenDelete<cr>',                'Delete output')
map('n', '<leader>jx', '<cmd>MoltenInterrupt<cr>',             'Interrupt kernel')
map('n', '<leader>jR', '<cmd>MoltenRestart<cr>',               'Restart kernel')
map('n', '<leader>jn', '<cmd>MoltenNext<cr>',                  'Next cell')
map('n', '<leader>jp', '<cmd>MoltenPrev<cr>',                  'Previous cell')

map('n', '<leader>hs', function() require('gitsigns').stage_hunk() end,        'Stage hunk')
map('n', '<leader>hr', function() require('gitsigns').reset_hunk() end,        'Reset hunk')
map('n', '<leader>hu', function() require('gitsigns').undo_stage_hunk() end,   'Unstage hunk')
map('n', '<leader>hS', function() require('gitsigns').stage_buffer() end,      'Stage file')
map('n', '<leader>hR', function() require('gitsigns').reset_buffer() end,      'Reset file')
map('n', '<leader>hp', function() require('gitsigns').preview_hunk() end,      'Preview hunk')
map('n', '<leader>hb', function() require('gitsigns').toggle_current_line_blame() end,
  'Toggle line blame')
map('n', ']h',        function() require('gitsigns').next_hunk() end,          'Next hunk')
map('n', '[h',        function() require('gitsigns').prev_hunk() end,          'Previous hunk')
map('v', '<leader>hs', function() require('gitsigns').stage_hunk({vim.fn.line('.'), vim.fn.line('v')}) end,
  'Stage selection')
map('v', '<leader>hr', function() require('gitsigns').reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end,
  'Reset selection')

map('n', '<leader>gd', '<cmd>DiffviewOpen<CR>',                        'Diff vs HEAD')
map('n', '<leader>gr', '<cmd>DiffviewOpen origin/main...HEAD<CR>',     'Review branch vs main')
map('n', '<leader>gD', '<cmd>DiffviewClose<CR>',                       'Close diff')
map('n', '<leader>gR', '<cmd>RefreshExternalChanges<CR>',              'Refresh after external changes')
map('n', '<leader>gh', '<cmd>DiffviewFileHistory %<CR>',               'File history')
map('n', '<leader>gH', '<cmd>DiffviewFileHistory<CR>',                 'Repo history')
map('n', '<leader>gf', '<cmd>DiffviewToggleFiles<CR>',                 'Toggle diff files')
map('n', '<leader>gF', '<cmd>DiffviewFocusFiles<CR>',                  'Focus diff files')

map('n', '<leader>ma', function() require('harpoon'):list():add() end,     'Add file')
map('n', '<leader>mm', function()
  local harpoon = require('harpoon')
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, 'Menu')
map('n', '<leader>mn', function() require('harpoon'):list():next() end,    'Next file')
map('n', '<leader>mp', function() require('harpoon'):list():prev() end,    'Previous file')
map('n', '<leader>m1', function() require('harpoon'):list():select(1) end, 'File 1')
map('n', '<leader>m2', function() require('harpoon'):list():select(2) end, 'File 2')
map('n', '<leader>m3', function() require('harpoon'):list():select(3) end, 'File 3')
map('n', '<leader>m4', function() require('harpoon'):list():select(4) end, 'File 4')
map('n', '<leader>m5', function() require('harpoon'):list():select(5) end, 'File 5')

map('n', '<leader>ac', '<cmd>ClaudeCode<cr>',                   'Toggle Claude')
map('n', '<leader>af', '<cmd>ClaudeCodeFocus<cr>',              'Focus Claude')
map('n', '<leader>ar', '<cmd>ClaudeCode --resume<cr>',          'Resume session')
map('n', '<leader>aC', '<cmd>ClaudeCode --continue<cr>',        'Continue last session')
map('n', '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>',        'Select model')
map('n', '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>',              'Add current file')
map('v', '<leader>as', '<cmd>ClaudeCodeSend<cr>',               'Send selection')
map('n', '<leader>al', 'V<cmd>ClaudeCodeSend<cr>',              'Send current line')
map('n', '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>',         'Accept diff')
map('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>',           'Reject diff')

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
  callback = function(ev)
    set('n', '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>',
      { buffer = ev.buf, noremap = true, silent = true, desc = 'Add file' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'NvimTree',
  callback = function(ev)
    local api = require('nvim-tree.api')
    local bufnr = ev.buf

    local function bufmap(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = 'nvim-tree: ' .. desc })
    end

    bufmap('n', '<CR>', api.node.open.edit, 'Open')
    bufmap('n', 'o', api.node.open.edit, 'Open')
    bufmap('n', 'i', api.node.open.horizontal, 'Open: Horizontal Split')
    bufmap('n', 's', api.node.open.vertical, 'Open: Vertical Split')
    bufmap('n', 't', api.node.open.tab, 'Open: New Tab')
    bufmap('n', 'v', api.node.open.vertical, 'Open: Vertical Split')
    bufmap('n', '<C-v>', api.node.open.vertical, 'Open: Vertical Split')
    bufmap('n', '<C-x>', api.node.open.horizontal, 'Open: Horizontal Split')
    bufmap('n', '<C-t>', api.node.open.tab, 'Open: New Tab')

    bufmap('n', '<', api.node.navigate.sibling.prev, 'Previous Sibling')
    bufmap('n', '>', api.node.navigate.sibling.next, 'Next Sibling')
    bufmap('n', 'P', api.node.navigate.parent, 'Parent Directory')
    bufmap('n', '<BS>', api.node.navigate.parent_close, 'Close Directory')
    bufmap('n', '<Tab>', api.node.open.preview, 'Open Preview')
    bufmap('n', 'K', api.node.navigate.sibling.first, 'First Sibling')
    bufmap('n', 'J', api.node.navigate.sibling.last, 'Last Sibling')

    bufmap('n', 'I', api.tree.toggle_gitignore_filter, 'Toggle Git Ignore')
    bufmap('n', 'H', api.tree.toggle_hidden_filter, 'Toggle Dotfiles')
    bufmap('n', 'R', api.tree.reload, 'Refresh')

    bufmap('n', 'a', api.fs.create, 'Create')
    bufmap('n', 'd', api.fs.remove, 'Delete')
    bufmap('n', 'D', api.fs.trash, 'Trash')
    bufmap('n', 'r', api.fs.rename, 'Rename')
    bufmap('n', '<C-r>', api.fs.rename_sub, 'Rename: Omit Filename')
    bufmap('n', 'x', api.fs.cut, 'Cut')
    bufmap('n', 'c', api.fs.copy.node, 'Copy')
    bufmap('n', 'p', api.fs.paste, 'Paste')

    bufmap('n', 'y', api.fs.copy.filename, 'Copy Name')
    bufmap('n', 'Y', api.fs.copy.relative_path, 'Copy Relative Path')
    bufmap('n', 'gy', api.fs.copy.absolute_path, 'Copy Absolute Path')

    bufmap('n', '[c', api.node.navigate.git.prev, 'Prev Git')
    bufmap('n', ']c', api.node.navigate.git.next, 'Next Git')

    bufmap('n', '-', api.tree.change_root_to_parent, 'Up')
    bufmap('n', 'q', api.tree.close, 'Close')
    bufmap('n', 'g?', api.tree.toggle_help, 'Help')
  end,
})

local bottom_term_buf
local function toggle_bottom_term()
  if bottom_term_buf and vim.api.nvim_buf_is_valid(bottom_term_buf) then
    local win = vim.fn.bufwinid(bottom_term_buf)
    if win ~= -1 then
      vim.api.nvim_win_close(win, false)
      return
    end
    vim.cmd('botright split | resize 12')
    vim.api.nvim_win_set_buf(0, bottom_term_buf)
  else
    vim.cmd('botright split | resize 12 | terminal')
    bottom_term_buf = vim.api.nvim_get_current_buf()
  end
  vim.cmd('startinsert')
end
map('n', '<leader>T', toggle_bottom_term, 'Bottom terminal')

map('n', '<leader>tw', function()
  local w = vim.wo
  w.wrap = not w.wrap
  w.linebreak = w.wrap
  w.breakindent = w.wrap
  w.showbreak = w.wrap and '↳ ' or ''
  w.breakindentopt = 'shift:2,sbr'
end, 'Toggle soft-wrap')

local function SoftWrapAt(cols)
  vim.wo.wrap = true
  vim.wo.linebreak = true
  vim.wo.breakindent = true
  vim.wo.showbreak = '↳ '
  vim.wo.breakindentopt = 'shift:2,sbr'
  vim.cmd('vertical resize ' .. tonumber(cols))
end

map('n', '<leader>w8', function() SoftWrapAt(80) end,  '80 columns')
map('n', '<leader>w0', function() SoftWrapAt(100) end, '100 columns')
map('n', '<leader>w2', function() SoftWrapAt(120) end, '120 columns')

local api = require("Comment.api")
map("n", "<leader>/", api.toggle.linewise.current, "Toggle comment")
map("x", "<leader>/", function()
  api.toggle.linewise(vim.fn.visualmode())
end, "Toggle comment")

map("n", "gcc", api.toggle.linewise.current, "Toggle comment")
map("n", "gbc", api.toggle.blockwise.current, "Toggle block comment")

map("x", "gc", function() api.toggle.linewise(vim.fn.visualmode()) end, "Comment (line)")
map("x", "gb", function() api.toggle.blockwise(vim.fn.visualmode()) end, "Block comment")

set("n", "gc", function()
  return api.call("toggle.linewise", "g@")
end, { expr = true, silent = true, desc = "Comment (operator)" })

set("n", "gb", function()
  return api.call("toggle.blockwise", "g@")
end, { expr = true, silent = true, desc = "Block comment (operator)" })

map("n", "gco", api.insert.linewise.below, "Comment below")
map("n", "gcO", api.insert.linewise.above, "Comment above")
map("n", "gcA", api.insert.linewise.eol,   "Comment at end of line")

map({'n', 'x', 'o'}, 's', function() require("flash").jump() end, 'Flash jump')
map({'n', 'o'}, 'S', function() require("flash").treesitter() end, 'Flash Treesitter select')
map('o', 'r', function() require("flash").remote() end, 'Flash remote')
map({'o', 'x'}, 'R', function() require("flash").treesitter_search() end, 'Flash Treesitter search')
map('c', '<c-s>', function() require("flash").toggle() end, 'Toggle Flash search')

map('n', ']t', function() require("todo-comments").jump_next() end, 'Next TODO')
map('n', '[t', function() require("todo-comments").jump_prev() end, 'Previous TODO')
map('n', '<leader>ft', '<cmd>TodoTelescope<cr>', 'TODO comments')
map('n', '<leader>fT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>', 'TODO / FIX / FIXME')

map('n', '<leader>qs', function() require("persistence").load() end, 'Restore session (this dir)')
map('n', '<leader>ql', function() require("persistence").load({ last = true }) end, 'Restore last session')
map('n', '<leader>qd', function() require("persistence").stop() end, 'Don\'t save session')

map('n', '<leader>goj', '<cmd>GoTagAdd json<cr>', 'Add json tags')
map('n', '<leader>goy', '<cmd>GoTagAdd yaml<cr>', 'Add yaml tags')
map('n', '<leader>goe', '<cmd>GoIfErr<cr>', 'Insert if err')
map('n', '<leader>got', function() neotest_run(vim.api.nvim_buf_get_name(0)) end, 'Test function')
map('n', '<leader>goT', function()
  local file = vim.fn.expand('%:p')
  neotest_run(file, { file })
end, 'Test file')
map('n', '<leader>goa', function()
  local dir = vim.fn.expand('%:p:h')
  neotest_run(dir, { dir })
end, 'Test package')
map('n', '<leader>goc', function()
  local env = go_test_env(vim.api.nvim_buf_get_name(0))
  if not env then return end
  local saved = {}
  for k, v in pairs(env) do
    saved[k] = vim.env[k]
    vim.env[k] = v
  end
  vim.cmd('GoCoverage')
  for k in pairs(env) do
    vim.env[k] = saved[k]
  end
end, 'Coverage')
map('n', '<leader>gom', '<cmd>GoMockGen<cr>', 'Generate mock')
map('n', '<leader>goi', '<cmd>GoImpl<cr>', 'Implement interface')
map('n', '<leader>gof', '<cmd>GoFillStruct<cr>', 'Fill struct')
map('n', '<leader>gos', '<cmd>GoFillSwitch<cr>', 'Fill switch')

map('n', '<leader>goo', function()
  vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' }, diagnostics = {} }, apply = true })
end, 'Organize imports')

map('n', '<leader>goq', function()
  vim.lsp.buf.code_action({
    context = { only = { 'quickfix' } },
    filter = function(action) return (action.title or ''):lower():find('import', 1, true) ~= nil end,
    apply = true,
  })
end, 'Add missing import')

map('n', '<leader>god', function() require('apascualco.gomain').debug() end, 'Debug main.go')
map('n', '<leader>gor', function() require('apascualco.gomain').run() end,   'Run main.go')

map('n', '<leader>gob', function()
  local dir = vim.fn.expand('%:p:h')
  vim.cmd('!cd ' .. vim.fn.shellescape(dir) .. ' && go build .')
end, 'Build package')

map('n', '<leader>gmt', '<cmd>!go mod tidy<CR>', 'go mod tidy')
map('n', '<leader>gmv', '<cmd>!go mod vendor<CR>', 'go mod vendor')
map('n', '<leader>gmd', '<cmd>!go mod download<CR>', 'go mod download')

map('n', '<leader>gmg', function()
  vim.ui.input({ prompt = 'go get: ' }, function(input)
    if input then
      vim.cmd('!go get ' .. input)
    end
  end)
end, 'go get')

map('n', '<leader>goA', function()
  vim.cmd('GoTagAdd json')
  vim.cmd('GoTagAdd yaml')
end, 'Add json + yaml tags')

map('n', '<leader>goR', '<cmd>GoTagRm<CR>', 'Remove tags')

map('n', '<leader>gol', function() require('neotest').run.run_last() end, 'Rerun last test')

map('n', '<leader>gog', '<cmd>!go generate ./...<CR>', 'go generate')

map('n', '<leader>gmi', function()
  vim.ui.input({ prompt = 'Module name: ' }, function(input)
    if input then
      vim.cmd('!go mod init ' .. input)
    end
  end)
end, 'go mod init')

map({'n', 't'}, '<C-\\>', '<cmd>ToggleTerm<cr>', 'Toggle terminal')

for i = 1, 9 do
  map('n', '<leader>t' .. i, '<cmd>' .. i .. 'ToggleTerm<cr>', 'Terminal ' .. i)
end

map('t', '<C-PageDown>', function()
  local terms = require('toggleterm.terminal').get_all()
  if #terms > 1 then
    vim.cmd('ToggleTerm')
    vim.defer_fn(function() vim.cmd((vim.v.count > 0 and vim.v.count or 2) .. 'ToggleTerm') end, 50)
  end
end, 'Next terminal')
map('t', '<C-PageUp>', function()
  local terms = require('toggleterm.terminal').get_all()
  if #terms > 1 then
    vim.cmd('ToggleTerm')
    vim.defer_fn(function() vim.cmd('1ToggleTerm') end, 50)
  end
end, 'Previous terminal')

map('n', '<leader>tq', '<cmd>ToggleTermToggleAll<cr>', 'Close all terminals')

local lazydocker
map('n', '<leader>rd', function()
  if not lazydocker then
    lazydocker = require('toggleterm.terminal').Terminal:new({
      cmd = 'lazydocker',
      direction = 'float',
      hidden = true,
      close_on_exit = true,
      on_exit = function() lazydocker = nil end,
    })
  end
  lazydocker:toggle()
end, 'Lazydocker')

map('n', '<C-h>', '<cmd>TmuxNavigateLeft<cr>',  'Go to left window / pane')
map('n', '<C-j>', '<cmd>TmuxNavigateDown<cr>', 'Go to lower window / pane')
map('n', '<C-k>', '<cmd>TmuxNavigateUp<cr>',   'Go to upper window / pane')
map('n', '<C-l>', '<cmd>TmuxNavigateRight<cr>', 'Go to right window / pane')

map('t', '<C-h>', '<C-\\><C-n><C-w>h', 'Go to left window')
map('t', '<C-j>', '<C-\\><C-n><C-w>j', 'Go to lower window')
map('t', '<C-k>', '<C-\\><C-n><C-w>k', 'Go to upper window')
map('t', '<C-l>', '<C-\\><C-n><C-w>l', 'Go to right window')

map('n', '<C-w><Left>', '<C-w>h', 'Go to left window')
map('n', '<C-w><Down>', '<C-w>j', 'Go to lower window')
map('n', '<C-w><Up>', '<C-w>k', 'Go to upper window')
map('n', '<C-w><Right>', '<C-w>l', 'Go to right window')

map('n', '<C-Up>', '<cmd>resize +2<CR>', 'Increase height')
map('n', '<C-Down>', '<cmd>resize -2<CR>', 'Decrease height')
map('n', '<C-Left>', '<cmd>vertical resize -2<CR>', 'Decrease width')
map('n', '<C-Right>', '<cmd>vertical resize +2<CR>', 'Increase width')

map('x', 'p', '"_dP', 'Paste without yanking')

map('v', '<', '<gv', 'Unindent (keep selection)')
map('v', '>', '>gv', 'Indent (keep selection)')

map('n', '<A-j>', '<cmd>m .+1<CR>==', 'Move line down')
map('n', '<A-k>', '<cmd>m .-2<CR>==', 'Move line up')
map('v', '<A-j>', ":m '>+1<CR>gv=gv", 'Move selection down')
map('v', '<A-k>', ":m '<-2<CR>gv=gv", 'Move selection up')

map('n', '<Esc>', '<cmd>nohlsearch<CR>', 'Clear search highlight')

map('n', '<C-s>', '<cmd>w<CR>', 'Save file')
map('i', '<C-s>', '<Esc><cmd>w<CR>a', 'Save file (insert mode)')

map('n', 'K', vim.lsp.buf.hover, 'Hover docs')
map('n', 'gd', function() require('telescope.builtin').lsp_definitions() end, 'Go to definition')
map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
for _, lhs in ipairs({ 'grn', 'gra', 'grr', 'gri', 'grt', 'grx' }) do
  pcall(vim.keymap.del, 'n', lhs)
end
map('n', 'gr', function() require('telescope.builtin').lsp_references() end, 'References')
map('n', 'gi', function() require('telescope.builtin').lsp_implementations() end, 'Go to implementation')
map('n', 'gt', function() require('telescope.builtin').lsp_type_definitions() end, 'Go to type definition')

set('n', '<C-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>',
  { noremap = true, silent = true, desc = 'Go to definition' })

map('n', ']q', '<cmd>cnext<CR>', 'Next quickfix')
map('n', '[q', '<cmd>cprev<CR>', 'Previous quickfix')
map('n', ']l', '<cmd>lnext<CR>', 'Next location')
map('n', '[l', '<cmd>lprev<CR>', 'Previous location')
map('n', '<leader>co', '<cmd>copen<CR>', 'Open quickfix')
map('n', '<leader>cc', '<cmd>cclose<CR>', 'Close quickfix')
map('n', '<leader>Lo', '<cmd>lopen<CR>', 'Open location list')
map('n', '<leader>Lc', '<cmd>lclose<CR>', 'Close location list')

map('n', '<leader>sv', '<cmd>vsplit<CR>', 'Split vertical')
map('n', '<leader>sh', '<cmd>split<CR>', 'Split horizontal')
map('n', '<leader>sx', '<cmd>close<CR>', 'Close split')
map('n', '<leader>so', '<cmd>only<CR>', 'Close other windows')
map('n', '<leader>se', '<C-w>=', 'Equalize windows')
map('n', '<leader>sm', function()
  if vim.t.maximized then
    vim.cmd('wincmd =')
    vim.t.maximized = false
  else
    vim.cmd('wincmd |')
    vim.cmd('wincmd _')
    vim.t.maximized = true
  end
end, 'Maximize window')

map('n', '<leader>qw', '<cmd>q<CR>', 'Quit window')
map('n', '<leader>qq', '<cmd>confirm qa<CR>', 'Quit all (confirm unsaved)')
map('n', '<leader>Q', '<cmd>qa<CR>', 'Quit all')

map('n', '<leader>un', function()
  vim.wo.number = not vim.wo.number
  print('Line numbers: ' .. (vim.wo.number and 'ON' or 'OFF'))
end, 'Line numbers')

map('n', '<leader>ur', function()
  vim.wo.relativenumber = not vim.wo.relativenumber
  print('Relative numbers: ' .. (vim.wo.relativenumber and 'ON' or 'OFF'))
end, 'Relative numbers')

map('n', '<leader>us', function()
  vim.wo.spell = not vim.wo.spell
  print('Spell check: ' .. (vim.wo.spell and 'ON' or 'OFF'))
end, 'Spell check')

map('n', '<leader>uw', function()
  vim.wo.wrap = not vim.wo.wrap
  print('Wrap: ' .. (vim.wo.wrap and 'ON' or 'OFF'))
end, 'Wrap')

map('n', '<leader>bn', '<cmd>enew<CR>', 'New buffer')

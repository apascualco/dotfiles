local set = vim.keymap.set
local function map(mode, lhs, rhs, desc)
	set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end
local function telescope(name, opts)
	return function()
		require("telescope.builtin")[name](opts)
	end
end

map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", "File explorer")
map("n", "<leader>Ef", "<cmd>NvimTreeFocus<CR>", "Focus explorer")
map("n", "<leader>Ee", "<cmd>NvimTreeFindFile<CR>", "Reveal current file")
map("n", "<leader>Ec", "<cmd>NvimTreeCollapse<CR>", "Collapse all")
map("n", "<leader>Er", "<cmd>NvimTreeRefresh<CR>", "Refresh")

map("n", "<leader>ff", telescope("find_files"), "Find files")
map(
	"n",
	"<leader>fF",
	telescope("find_files", { no_ignore = true, hidden = true }),
	"Find all files (hidden + ignored)"
)
map("n", "<leader>fg", telescope("live_grep"), "Grep in project")
map("n", "<leader>fs", telescope("grep_string"), "Grep word under cursor")
map("n", "<leader>f/", telescope("current_buffer_fuzzy_find"), "Search in buffer")
map("n", "<leader>fw", function()
	require("telescope.builtin").current_buffer_fuzzy_find({ default_text = vim.fn.expand("<cword>") })
end, "Word under cursor in buffer")
map("n", "<leader>fb", telescope("buffers"), "Buffers")
map("n", "<leader>fB", telescope("git_branches", { show_remote_tracking_branches = false }), "Local branches")
map("n", "<leader>fS", telescope("git_stash"), "Git stashes")
map("n", "<leader>fo", telescope("oldfiles"), "Recent files")
map("n", "<leader>fh", telescope("help_tags"), "Help")
map("n", "<leader>fk", telescope("keymaps"), "Keymaps")
map("n", "<leader>fc", telescope("commands"), "Commands")
map("n", "<leader>f:", telescope("command_history"), "Command history")
map("n", "<leader>f?", telescope("search_history"), "Search history")
map("n", "<leader>fr", telescope("resume"), "Resume last search")
map("n", '<leader>f"', telescope("registers"), "Registers")
map("n", "<leader>fm", telescope("marks"), "Marks")
map("n", "<leader>fj", telescope("jumplist"), "Jump list")
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", "TODO comments")
map("n", "<leader>fT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", "TODO / FIX / FIXME")
map("n", "<leader>fn", function()
	Snacks.notifier.show_history()
end, "Notifications")
map("n", "<leader>ss", function()
	require("telescope").extensions.luasnip.luasnip()
end, "Snippets")

map("n", "<leader>gn", "<cmd>Neogit<CR>", "Neogit")
map("n", "<leader>gs", telescope("git_status"), "Status")
map("n", "<leader>gb", telescope("git_branches"), "Branches")
map("n", "<leader>gc", telescope("git_commits"), "Commits (repo)")
map("n", "<leader>gC", telescope("git_bcommits"), "Commits (this file)")
map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", "Diff vs HEAD")
map("n", "<leader>gr", "<cmd>DiffviewOpen origin/main...HEAD<CR>", "Review branch vs main")
map("n", "<leader>gD", "<cmd>DiffviewClose<CR>", "Close diff")
map("n", "<leader>gR", "<cmd>RefreshExternalChanges<CR>", "Refresh after external changes")
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", "File history")
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>", "Repo history")
map("n", "<leader>gf", "<cmd>DiffviewToggleFiles<CR>", "Toggle diff files")
map("n", "<leader>gF", "<cmd>DiffviewFocusFiles<CR>", "Focus diff files")

local function gitsigns(name, range)
	return function()
		local gs = require("gitsigns")
		if range then
			gs[name]({ vim.fn.line("."), vim.fn.line("v") })
		else
			gs[name]()
		end
	end
end
map("n", "<leader>hs", gitsigns("stage_hunk"), "Stage hunk")
map("n", "<leader>hr", gitsigns("reset_hunk"), "Reset hunk")
map("n", "<leader>hu", gitsigns("undo_stage_hunk"), "Unstage hunk")
map("n", "<leader>hS", gitsigns("stage_buffer"), "Stage file")
map("n", "<leader>hR", gitsigns("reset_buffer"), "Reset file")
map("n", "<leader>hp", gitsigns("preview_hunk"), "Preview hunk")
map("n", "<leader>hb", gitsigns("toggle_current_line_blame"), "Toggle line blame")
map("n", "]h", gitsigns("next_hunk"), "Next hunk")
map("n", "[h", gitsigns("prev_hunk"), "Previous hunk")
map("v", "<leader>hs", gitsigns("stage_hunk", true), "Stage selection")
map("v", "<leader>hr", gitsigns("reset_hunk", true), "Reset selection")

map("n", "K", vim.lsp.buf.hover, "Hover docs")
map("n", "gd", telescope("lsp_definitions"), "Go to definition")
map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
for _, lhs in ipairs({ "grn", "gra", "grr", "gri", "grt", "grx" }) do
	pcall(vim.keymap.del, "n", lhs)
end
map("n", "gr", telescope("lsp_references"), "References")
map("n", "gi", telescope("lsp_implementations"), "Go to implementation")
map("n", "gt", telescope("lsp_type_definitions"), "Go to type definition")
map("n", "gl", vim.diagnostic.open_float, "Line diagnostics")
set(
	"n",
	"<C-LeftMouse>",
	"<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>",
	{ noremap = true, silent = true, desc = "Go to definition" }
)

map("n", "<leader>lr", telescope("lsp_references"), "References")
map("n", "<leader>li", telescope("lsp_implementations"), "Implementations")
map("n", "<leader>ls", telescope("lsp_document_symbols"), "Document symbols")
map("n", "<leader>lS", telescope("lsp_workspace_symbols"), "Workspace symbols")
map("n", "<leader>lh", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, "Toggle inlay hints")
map("n", "<leader>lI", "<cmd>checkhealth vim.lsp<CR>", "LSP status")
map("n", "<leader>lm", "<cmd>Mason<CR>", "Mason")
map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, "Code actions")
map("n", "<leader>lR", vim.lsp.buf.rename, "Rename symbol")
map("n", "<leader>lD", vim.lsp.buf.declaration, "Go to declaration")
map("n", "<leader>ld", vim.lsp.buf.definition, "Go to definition")
map("n", "<leader>lt", vim.lsp.buf.type_definition, "Go to type definition")
map("n", "<leader>lK", vim.lsp.buf.signature_help, "Signature help")
map({ "n", "x" }, "<leader>lf", function()
	vim.lsp.buf.format({ async = true })
end, "Format with LSP")
map("n", "<leader>le", vim.diagnostic.open_float, "Diagnostic at cursor")
map("n", "<leader>lq", vim.diagnostic.setloclist, "Diagnostics to location list")
map("n", "<leader>lc", vim.lsp.codelens.run, "Run code lens")
map("n", "<leader>lx", function()
	vim.lsp.enable(vim.tbl_map(function(c)
		return c.name
	end, vim.lsp.get_configs({ enabled = true })))
end, "Reattach LSP")
map("n", "<leader>dd", telescope("diagnostics"), "Search diagnostics")

map("i", "<C-Space>", function()
	require("cmp").complete()
end, "Trigger completion")
map("i", "<C-y>", function()
	require("cmp").confirm({ select = true })
end, "Confirm completion")
map("i", "<C-e>", function()
	require("cmp").abort()
end, "Abort completion")
map({ "i", "s" }, "<C-j>", function()
	require("luasnip").jump(1)
end, "Next snippet field")
map({ "i", "s" }, "<C-k>", function()
	require("luasnip").jump(-1)
end, "Previous snippet field")

map("n", "<leader>cf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, "Format file")
map("n", "<leader>co", "<cmd>copen<CR>", "Open quickfix")
map("n", "<leader>cc", "<cmd>cclose<CR>", "Close quickfix")
map("n", "<leader>Lo", "<cmd>lopen<CR>", "Open location list")
map("n", "<leader>Lc", "<cmd>lclose<CR>", "Close location list")
map("n", "]q", "<cmd>cnext<CR>", "Next quickfix")
map("n", "[q", "<cmd>cprev<CR>", "Previous quickfix")
map("n", "]l", "<cmd>lnext<CR>", "Next location")
map("n", "[l", "<cmd>lprev<CR>", "Previous location")

map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", "Workspace diagnostics")
map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", "Buffer diagnostics")
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>", "Location list")
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", "Quickfix list")
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", "Document symbols")
map("n", "<leader>xL", "<cmd>Trouble lsp toggle focus=false<CR>", "LSP panel")
map("n", "<leader>xr", "<cmd>Trouble lsp_references<CR>", "LSP references")

local function dap(name)
	return function()
		require("dap")[name]()
	end
end
map("n", "<leader>db", dap("toggle_breakpoint"), "Toggle breakpoint")
map("n", "<leader>dB", function()
	vim.ui.input({ prompt = "Breakpoint condition: " }, function(cond)
		if cond then
			require("dap").set_breakpoint(cond)
		end
	end)
end, "Conditional breakpoint")
map("n", "<leader>dL", function()
	vim.ui.input({ prompt = "Logpoint message: " }, function(msg)
		if msg then
			require("dap").set_breakpoint(nil, nil, msg)
		end
	end)
end, "Logpoint")
map("n", "<leader>dc", dap("continue"), "Start / continue")
map("n", "<leader>dn", dap("step_over"), "Step over")
map("n", "<leader>di", dap("step_into"), "Step into")
map("n", "<leader>do", dap("step_out"), "Step out")
map("n", "<leader>dl", dap("run_last"), "Rerun last")
map("n", "<leader>dr", function()
	require("dap").repl.toggle()
end, "Toggle REPL")
map("n", "<leader>dt", function()
	require("dap").terminate()
	require("dapui").close()
end, "Stop and close UI")
map("n", "<leader>du", function()
	require("dapui").toggle()
end, "Toggle UI")
map("n", "<leader>de", function()
	require("dapui").eval()
end, "Evaluate expression")
map({ "n", "x" }, "<leader>dv", function()
	require("dap.ui.widgets").hover()
end, "Inspect value")

map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", "Next buffer")
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", "Previous buffer")
map("n", "<C-A-Left>", "<cmd>BufferLineCyclePrev<CR>", "Previous buffer")
map("n", "<C-A-Right>", "<cmd>BufferLineCycleNext<CR>", "Next buffer")
map("n", "<leader>bn", "<cmd>enew<CR>", "New buffer")
map("n", "<leader>bp", "<cmd>BufferLinePick<CR>", "Pick buffer")
map("n", "<leader>bc", "<cmd>bdelete<CR>", "Close buffer")
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", "Close others")
map("n", "<leader>br", "<cmd>BufferLineCloseRight<CR>", "Close all to the right")
map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", "Close all to the left")
map("n", "<leader>b>", "<cmd>BufferLineMoveNext<CR>", "Move right")
map("n", "<leader>b<", "<cmd>BufferLineMovePrev<CR>", "Move left")
map("n", "<leader>bsd", "<cmd>BufferLineSortByDirectory<CR>", "By directory")
map("n", "<leader>bse", "<cmd>BufferLineSortByExtension<CR>", "By extension")

map("n", "<leader>tt", "<cmd>TagbarToggle<CR>", "Toggle outline")
map("n", "<leader>to", "<cmd>TagbarOpen<CR>", "Open outline")
map("n", "<leader>td", function()
	require("tiny-inline-diagnostic").toggle()
end, "Toggle inline diagnostics")
map("n", "<leader>ti", "<cmd>Inspect<CR>", "Inspect highlight")
map("n", "<leader>tI", "<cmd>InspectTree<CR>", "Inspect syntax tree")
map("n", "<leader>ui", "<cmd>IBLToggle<CR>", "Indent guides")

map("n", "]]", function()
	Snacks.words.jump(vim.v.count1)
end, "Next reference")
map("n", "[[", function()
	Snacks.words.jump(-vim.v.count1)
end, "Previous reference")

map("n", "<leader>ji", "<cmd>MoltenInit<cr>", "Start kernel")
map("n", "<leader>jl", "<cmd>MoltenEvaluateLine<cr>", "Run line")
map("n", "<leader>jc", "<cmd>MoltenReevaluateCell<cr>", "Re-run cell")
map("n", "<leader>jr", "<cmd>MoltenEvaluateOperator<cr>", "Run (operator)")
map("x", "<leader>jv", ":<C-u>MoltenEvaluateVisual<cr>gv", "Run selection")
map("n", "<leader>jo", "<cmd>MoltenShowOutput<cr>", "Show output")
map("n", "<leader>jh", "<cmd>MoltenHideOutput<cr>", "Hide output")
map("n", "<leader>jd", "<cmd>MoltenDelete<cr>", "Delete output")
map("n", "<leader>jx", "<cmd>MoltenInterrupt<cr>", "Interrupt kernel")
map("n", "<leader>jR", "<cmd>MoltenRestart<cr>", "Restart kernel")
map("n", "<leader>jn", "<cmd>MoltenNext<cr>", "Next cell")
map("n", "<leader>jp", "<cmd>MoltenPrev<cr>", "Previous cell")

local function harpoon(fn)
	return function()
		local h = require("harpoon")
		fn(h, h:list())
	end
end
map(
	"n",
	"<leader>ma",
	harpoon(function(_, list)
		list:add()
	end),
	"Add file"
)
map(
	"n",
	"<leader>mm",
	harpoon(function(h, list)
		h.ui:toggle_quick_menu(list)
	end),
	"Menu"
)
map(
	"n",
	"<leader>mn",
	harpoon(function(_, list)
		list:next()
	end),
	"Next file"
)
map(
	"n",
	"<leader>mp",
	harpoon(function(_, list)
		list:prev()
	end),
	"Previous file"
)
for i = 1, 5 do
	map(
		"n",
		"<leader>m" .. i,
		harpoon(function(_, list)
			list:select(i)
		end),
		"File " .. i
	)
end

map("n", "<leader>ac", "<cmd>ClaudeCode<cr>", "Toggle Claude")
map("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", "Focus Claude")
map("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", "Resume session")
map("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", "Continue last session")
map("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", "Select model")
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", "Add current file")
map("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", "Send selection")
map("n", "<leader>al", "V<cmd>ClaudeCodeSend<cr>", "Send current line")
map("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", "Accept diff")
map("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", "Reject diff")

local bottom_term_buf
map("n", "<leader>T", function()
	if bottom_term_buf and vim.api.nvim_buf_is_valid(bottom_term_buf) then
		local win = vim.fn.bufwinid(bottom_term_buf)
		if win ~= -1 then
			vim.api.nvim_win_close(win, false)
			return
		end
		vim.cmd("botright split | resize 12")
		vim.api.nvim_win_set_buf(0, bottom_term_buf)
	else
		vim.cmd("botright split | resize 12 | terminal")
		bottom_term_buf = vim.api.nvim_get_current_buf()
	end
	vim.cmd("startinsert")
end, "Bottom terminal")

map({ "n", "t" }, "<C-\\>", "<cmd>ToggleTerm<cr>", "Toggle terminal")
for i = 1, 9 do
	map("n", "<leader>t" .. i, "<cmd>" .. i .. "ToggleTerm<cr>", "Terminal " .. i)
end
map("t", "<C-PageDown>", function()
	if #require("toggleterm.terminal").get_all() > 1 then
		vim.cmd("ToggleTerm")
		vim.defer_fn(function()
			vim.cmd((vim.v.count > 0 and vim.v.count or 2) .. "ToggleTerm")
		end, 50)
	end
end, "Next terminal")
map("t", "<C-PageUp>", function()
	if #require("toggleterm.terminal").get_all() > 1 then
		vim.cmd("ToggleTerm")
		vim.defer_fn(function()
			vim.cmd("1ToggleTerm")
		end, 50)
	end
end, "Previous terminal")
map("n", "<leader>tq", "<cmd>ToggleTermToggleAll<cr>", "Close all terminals")

local lazydocker
map("n", "<leader>rd", function()
	if not lazydocker then
		lazydocker = require("toggleterm.terminal").Terminal:new({
			cmd = "lazydocker",
			direction = "float",
			hidden = true,
			close_on_exit = true,
			on_exit = function()
				lazydocker = nil
			end,
		})
	end
	lazydocker:toggle()
end, "Lazydocker")

map("n", "<leader>tw", function()
	local w = vim.wo
	w.wrap = not w.wrap
	w.linebreak = w.wrap
	w.breakindent = w.wrap
	w.showbreak = w.wrap and "↳ " or ""
	w.breakindentopt = "shift:2,sbr"
end, "Toggle soft-wrap")
local function soft_wrap_at(cols)
	return function()
		vim.wo.wrap = true
		vim.wo.linebreak = true
		vim.wo.breakindent = true
		vim.wo.showbreak = "↳ "
		vim.wo.breakindentopt = "shift:2,sbr"
		vim.cmd("vertical resize " .. cols)
	end
end
map("n", "<leader>w8", soft_wrap_at(80), "80 columns")
map("n", "<leader>w0", soft_wrap_at(100), "100 columns")
map("n", "<leader>w2", soft_wrap_at(120), "120 columns")

local comment = require("Comment.api")
map("n", "<leader>/", comment.toggle.linewise.current, "Toggle comment")
map("x", "<leader>/", function()
	comment.toggle.linewise(vim.fn.visualmode())
end, "Toggle comment")
map("n", "gcc", comment.toggle.linewise.current, "Toggle comment")
map("n", "gbc", comment.toggle.blockwise.current, "Toggle block comment")
map("x", "gc", function()
	comment.toggle.linewise(vim.fn.visualmode())
end, "Comment (line)")
map("x", "gb", function()
	comment.toggle.blockwise(vim.fn.visualmode())
end, "Block comment")
set("n", "gc", function()
	return comment.call("toggle.linewise", "g@")
end, { expr = true, silent = true, desc = "Comment (operator)" })
set("n", "gb", function()
	return comment.call("toggle.blockwise", "g@")
end, { expr = true, silent = true, desc = "Block comment (operator)" })
map("n", "gco", comment.insert.linewise.below, "Comment below")
map("n", "gcO", comment.insert.linewise.above, "Comment above")
map("n", "gcA", comment.insert.linewise.eol, "Comment at end of line")

map({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, "Flash jump")
map({ "n", "o" }, "S", function()
	require("flash").treesitter()
end, "Flash Treesitter select")
map("o", "r", function()
	require("flash").remote()
end, "Flash remote")
map({ "o", "x" }, "R", function()
	require("flash").treesitter_search()
end, "Flash Treesitter search")
map("c", "<c-s>", function()
	require("flash").toggle()
end, "Toggle Flash search")

map("n", "]t", function()
	require("todo-comments").jump_next()
end, "Next TODO")
map("n", "[t", function()
	require("todo-comments").jump_prev()
end, "Previous TODO")

map("n", "<leader>qs", function()
	require("persistence").load()
end, "Restore session (this dir)")
map("n", "<leader>ql", function()
	require("persistence").load({ last = true })
end, "Restore last session")
map("n", "<leader>qd", function()
	require("persistence").stop()
end, "Don't save session")
map("n", "<leader>qw", "<cmd>q<CR>", "Quit window")
map("n", "<leader>qq", "<cmd>confirm qa<CR>", "Quit all (confirm unsaved)")
map("n", "<leader>Q", "<cmd>qa<CR>", "Quit all")

map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", "Go to left window / pane")
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", "Go to lower window / pane")
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", "Go to upper window / pane")
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", "Go to right window / pane")
map("t", "<C-h>", "<C-\\><C-n><C-w>h", "Go to left window")
map("t", "<C-j>", "<C-\\><C-n><C-w>j", "Go to lower window")
map("t", "<C-k>", "<C-\\><C-n><C-w>k", "Go to upper window")
map("t", "<C-l>", "<C-\\><C-n><C-w>l", "Go to right window")
map("n", "<C-w><Left>", "<C-w>h", "Go to left window")
map("n", "<C-w><Down>", "<C-w>j", "Go to lower window")
map("n", "<C-w><Up>", "<C-w>k", "Go to upper window")
map("n", "<C-w><Right>", "<C-w>l", "Go to right window")
map("n", "<C-Up>", "<cmd>resize +2<CR>", "Increase height")
map("n", "<C-Down>", "<cmd>resize -2<CR>", "Decrease height")
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", "Decrease width")
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", "Increase width")

map("n", "<leader>sv", "<cmd>vsplit<CR>", "Split vertical")
map("n", "<leader>sh", "<cmd>split<CR>", "Split horizontal")
map("n", "<leader>sx", "<cmd>close<CR>", "Close split")
map("n", "<leader>so", "<cmd>only<CR>", "Close other windows")
map("n", "<leader>se", "<C-w>=", "Equalize windows")
map("n", "<leader>sm", function()
	if vim.t.maximized then
		vim.cmd("wincmd =")
		vim.t.maximized = false
	else
		vim.cmd("wincmd |")
		vim.cmd("wincmd _")
		vim.t.maximized = true
	end
end, "Maximize window")

map("x", "p", '"_dP', "Paste without yanking")
map("v", "<", "<gv", "Unindent (keep selection)")
map("v", ">", ">gv", "Indent (keep selection)")
map("n", "<A-j>", "<cmd>m .+1<CR>==", "Move line down")
map("n", "<A-k>", "<cmd>m .-2<CR>==", "Move line up")
map("v", "<A-j>", ":m '>+1<CR>gv=gv", "Move selection down")
map("v", "<A-k>", ":m '<-2<CR>gv=gv", "Move selection up")
map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlight")
map("n", "<C-s>", "<cmd>w<CR>", "Save file")
map("i", "<C-s>", "<Esc><cmd>w<CR>a", "Save file (insert mode)")

local function toggle_option(name, label)
	return function()
		vim.wo[name] = not vim.wo[name]
		print(label .. ": " .. (vim.wo[name] and "ON" or "OFF"))
	end
end
map("n", "<leader>un", toggle_option("number", "Line numbers"), "Line numbers")
map("n", "<leader>ur", toggle_option("relativenumber", "Relative numbers"), "Relative numbers")
map("n", "<leader>us", toggle_option("spell", "Spell check"), "Spell check")
map("n", "<leader>uw", toggle_option("wrap", "Wrap"), "Wrap")

require("apascualco.lang").register_fallbacks()

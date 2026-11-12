local M = {}

local ns = vim.api.nvim_create_namespace("apascualco-play")
local left_mouse = vim.keycode("<LeftMouse>")
local right_mouse = vim.keycode("<RightMouse>")
local marks = {}

local test_go = { "_test%.go$" }
local test_py = { "^test_.*%.py$", "_test%.py$" }

local defaults = {
	priority = 15,
	buttons = {
		run = { icon = vim.fn.nr2char(0xf04b), hl = "ApascualcoPlayRun", action = "<leader>kr", env = true },
		debug = { icon = vim.fn.nr2char(0xf188), hl = "ApascualcoPlayDebug", action = "<leader>kd", env = true },
		test = { icon = vim.fn.nr2char(0xf0c3), hl = "ApascualcoPlayTest", action = "<leader>nn" },
		file = { icon = vim.fn.nr2char(0xf04e), hl = "ApascualcoPlayRun", action = "<leader>nf" },
	},
	entries = {
		go = {
			{
				buttons = { "run", "debug" },
				patterns = { "^func%s+main%s*%(%s*%)" },
				requires = "^package%s+main%f[%W]",
			},
			{ buttons = { "file" }, patterns = { "^package%s" }, files = test_go, first = true },
			{
				buttons = { "test" },
				patterns = {
					"^func%s+Test%f[^%l]",
					"^func%s+%b()%s*Test%f[^%l]",
					"^func%s+Benchmark%f[^%l]",
					"^func%s+Fuzz%f[^%l]",
				},
				files = test_go,
			},
		},
		python = {
			{ buttons = { "run", "debug" }, patterns = { "^if%s+__name__%s*==%s*[\"']__main__[\"']" } },
			{ buttons = { "file" }, first_line = true, files = test_py },
			{
				buttons = { "test" },
				patterns = { "^%s*def%s+test", "^%s*async%s+def%s+test", "^class%s+Test" },
				files = test_py,
			},
		},
		java = {
			{ buttons = { "run", "debug" }, patterns = { "^%s*public%s+static%s+void%s+main%s*%(" } },
			{ buttons = { "file" }, patterns = { "^[%w%s]*class%s" }, requires = "^%s*@Test%f[%W]", first = true },
			{
				buttons = { "test" },
				patterns = { "^%s*@Test%f[%W]", "^%s*@ParameterizedTest%f[%W]" },
				annotation = true,
			},
		},
		rust = {
			{ buttons = { "run", "debug" }, patterns = { "^fn%s+main%s*%(", "^async%s+fn%s+main%s*%(" } },
			{ buttons = { "file" }, patterns = { "^%s*mod%s+tests%f[%W]" }, first = true },
			{ buttons = { "test" }, patterns = { "^%s*#%[test%]", "^%s*#%[tokio::test" }, annotation = true },
		},
	},
	env = {},
}

local config = defaults

local function any_match(text, patterns)
	for _, pattern in ipairs(patterns) do
		if text:find(pattern) then
			return true
		end
	end
	return false
end

local function annotated_target(lines, i)
	for j = i + 1, #lines do
		local line = lines[j]
		if not (line:find("^%s*$") or line:find("^%s*@") or line:find("^%s*#%[")) then
			return j
		end
	end
end

local function rule_rows(lines, name, rule)
	if rule.files and not any_match(name, rule.files) then
		return {}
	end
	local allowed = rule.requires == nil
	local rows = rule.first_line and #lines > 0 and { 1 } or {}
	for i, line in ipairs(lines) do
		if not allowed and line:find(rule.requires) then
			allowed = true
		end
		if rule.patterns and not (rule.first and #rows > 0) and any_match(line, rule.patterns) then
			table.insert(rows, rule.annotation and annotated_target(lines, i) or i)
		end
	end
	return allowed and rows or {}
end

local function scan(buf, rules)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local name = vim.fs.basename(vim.api.nvim_buf_get_name(buf))
	local found = {}
	for _, rule in ipairs(rules) do
		for _, lnum in ipairs(rule_rows(lines, name, rule)) do
			found[lnum] = found[lnum] or {}
			for _, button in ipairs(rule.buttons) do
				if not vim.tbl_contains(found[lnum], button) then
					table.insert(found[lnum], button)
				end
			end
		end
	end
	return found
end

local function update_signcolumn(buf, slots)
	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		local current = vim.wo[win].signcolumn
		if slots >= 2 and current == vim.go.signcolumn and current ~= "yes:2" then
			vim.api.nvim_set_option_value("signcolumn", "yes:2", { scope = "local", win = win })
			vim.b[buf].apascualco_play_signcolumn = true
		elseif slots < 2 and vim.b[buf].apascualco_play_signcolumn and current == "yes:2" then
			vim.api.nvim_set_option_value("signcolumn", vim.go.signcolumn, { scope = "local", win = win })
		end
	end
	if slots < 2 then
		vim.b[buf].apascualco_play_signcolumn = nil
	end
end

function M.refresh(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
	marks[buf] = nil
	local rules = config.entries[vim.bo[buf].filetype]
	local slots = 0
	if rules and vim.bo[buf].buftype == "" then
		marks[buf] = {}
		for lnum, names in pairs(scan(buf, rules)) do
			slots = math.max(slots, #names)
			for idx, name in ipairs(names) do
				local button = config.buttons[name]
				local id = vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, 0, {
					sign_text = button.icon,
					sign_hl_group = button.hl,
					priority = config.priority + #names - idx,
				})
				marks[buf][id] = name
			end
		end
	end
	update_signcolumn(buf, slots)
end

function M.trigger(buf, name)
	local action = config.buttons[name].action
	if type(action) == "function" then
		return action(buf)
	end
	local map = vim.fn.maparg(action, "n", false, true)
	if map.callback and map.expr ~= 1 then
		map.callback()
	elseif map.lhsraw then
		vim.api.nvim_feedkeys(map.lhsraw, "m", false)
	else
		vim.notify("apascualco-play: " .. action .. " no está mapeado", vim.log.levels.WARN)
	end
end

local function warn_if_not_ignored(path)
	vim.system({ "git", "check-ignore", "-q", path }, { cwd = vim.fs.dirname(path) }, function(res)
		if res.code == 1 then
			vim.schedule(function()
				vim.notify(
					vim.fs.basename(path) .. " no está en .gitignore: cuidado al hacer commit",
					vim.log.levels.WARN
				)
			end)
		end
	end)
end

local function save_env(ebuf, path)
	if not vim.api.nvim_buf_is_valid(ebuf) or not vim.bo[ebuf].modified then
		return
	end
	local text = table.concat(vim.api.nvim_buf_get_lines(ebuf, 0, -1, false), "")
	if not vim.uv.fs_stat(path) and text:match("^%s*$") then
		return
	end
	vim.api.nvim_buf_call(ebuf, function()
		vim.cmd("silent write")
	end)
	vim.notify("Variables guardadas en " .. vim.fn.fnamemodify(path, ":~:."))
	warn_if_not_ignored(path)
end

function M.edit_env(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	local ft = vim.bo[buf].filetype
	local resolver = config.env[ft]
	if not resolver then
		vim.notify("Variables de entorno no disponibles para " .. ft, vim.log.levels.INFO)
		return
	end
	local path, warning = resolver(buf)
	if warning then
		vim.notify(warning, vim.log.levels.WARN)
	end
	if not path then
		return
	end
	local existed = vim.fn.bufloaded(path) == 1
	local ebuf = vim.fn.bufadd(path)
	vim.fn.bufload(ebuf)
	local width = math.min(80, math.max(50, math.floor(vim.o.columns / 2)))
	local height = math.min(15, math.max(6, vim.api.nvim_buf_line_count(ebuf) + 2))
	local win = vim.api.nvim_open_win(ebuf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		border = "rounded",
		title = " Variables de entorno ",
		title_pos = "center",
		footer = " " .. vim.fn.fnamemodify(path, ":~:.") .. " · KEY=valor · q guarda y cierra ",
		footer_pos = "center",
	})
	local group = vim.api.nvim_create_augroup("ApascualcoPlayEnv", { clear = true })
	local function close()
		pcall(vim.api.nvim_del_augroup_by_id, group)
		if not vim.api.nvim_win_is_valid(win) then
			return
		end
		save_env(ebuf, path)
		pcall(vim.keymap.del, "n", "q", { buffer = ebuf })
		pcall(vim.keymap.del, "n", "<Esc>", { buffer = ebuf })
		vim.api.nvim_win_close(win, true)
		if not existed and vim.api.nvim_buf_is_valid(ebuf) then
			vim.api.nvim_buf_delete(ebuf, { force = true })
		end
	end
	vim.keymap.set("n", "q", close, { buffer = ebuf, nowait = true, desc = "Guardar y cerrar" })
	vim.keymap.set("n", "<Esc>", close, { buffer = ebuf, nowait = true, desc = "Guardar y cerrar" })
	vim.api.nvim_create_autocmd("WinLeave", {
		group = group,
		buffer = ebuf,
		callback = function()
			vim.schedule(close)
		end,
	})
	if vim.api.nvim_buf_line_count(ebuf) == 1 and vim.api.nvim_buf_get_lines(ebuf, 0, 1, false)[1] == "" then
		vim.cmd("startinsert")
	end
end

local function gutter(win)
	local info = vim.fn.getwininfo(win)[1]
	local wo = vim.wo[win]
	if not info or wo.statuscolumn ~= "" then
		return
	end
	local foldw = tonumber(wo.foldcolumn) or 0
	local numw = 0
	if wo.number or wo.relativenumber then
		local lines = wo.number and vim.api.nvim_buf_line_count(info.bufnr) or info.height
		numw = math.max(#tostring(lines), wo.numberwidth - 1) + 1
	end
	return foldw, info.textoff - foldw - numw
end

local function shown_sign(buf, row, slot, slots)
	local signs = {}
	for _, mark in
		ipairs(vim.api.nvim_buf_get_extmarks(buf, -1, { row, 0 }, { row, -1 }, { type = "sign", details = true }))
	do
		if mark[4].sign_text then
			table.insert(signs, mark)
		end
	end
	table.sort(signs, function(a, b)
		return a[4].priority > b[4].priority
	end)
	return slot <= slots and signs[slot] or nil
end

local function button_at(pos)
	if pos.winid == 0 or pos.line == 0 then
		return
	end
	local foldw, signw = gutter(pos.winid)
	if not foldw then
		return
	end
	local offset = pos.wincol - foldw
	if offset < 1 or offset > signw then
		return
	end
	local buf = vim.api.nvim_win_get_buf(pos.winid)
	local names = marks[buf]
	if not names then
		return
	end
	local row = pos.line - 1
	local mine = vim.api.nvim_buf_get_extmarks(buf, ns, { row, 0 }, { row, -1 }, {})
	if #mine == 0 then
		return
	end
	local shown = shown_sign(buf, row, math.floor((offset - 1) / 2) + 1, math.floor(signw / 2))
	local id = shown and shown[4].ns_id == ns and shown[1] or (#mine == 1 and mine[1][1]) or nil
	return id and names[id], buf
end

local function focus(pos)
	if not vim.api.nvim_win_is_valid(pos.winid) then
		return false
	end
	vim.api.nvim_set_current_win(pos.winid)
	vim.api.nvim_win_set_cursor(pos.winid, { pos.line, 0 })
	return true
end

local function on_key(_, typed)
	if typed ~= left_mouse and typed ~= right_mouse then
		return
	end
	local pos = vim.fn.getmousepos()
	local name, buf = button_at(pos)
	if not name then
		return
	end
	if typed == right_mouse then
		if not config.buttons[name].env then
			return
		end
		vim.schedule(function()
			if focus(pos) then
				M.edit_env(buf)
			end
		end)
		return ""
	end
	vim.schedule(function()
		if focus(pos) then
			M.trigger(buf, name)
		end
	end)
end

local function set_highlights()
	vim.api.nvim_set_hl(0, "ApascualcoPlayRun", { default = true, link = "DiagnosticOk" })
	vim.api.nvim_set_hl(0, "ApascualcoPlayDebug", { default = true, link = "DiagnosticWarn" })
	vim.api.nvim_set_hl(0, "ApascualcoPlayTest", { default = true, link = "DiagnosticInfo" })
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", defaults, opts or {})
	set_highlights()
	local group = vim.api.nvim_create_augroup("ApascualcoPlay", { clear = true })
	vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = set_highlights })
	vim.api.nvim_create_autocmd(
		{ "BufEnter", "BufWinEnter", "FileType", "BufWritePost", "TextChanged", "InsertLeave" },
		{
			group = group,
			callback = function(ev)
				M.refresh(ev.buf)
			end,
		}
	)
	vim.api.nvim_create_autocmd("BufWipeout", {
		group = group,
		callback = function(ev)
			marks[ev.buf] = nil
		end,
	})
	vim.api.nvim_create_user_command("ApascualcoPlayEnv", function()
		M.edit_env()
	end, { desc = "Editar variables de entorno del main" })
	vim.on_key(on_key, ns)
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			M.refresh(buf)
		end
	end
end

return M

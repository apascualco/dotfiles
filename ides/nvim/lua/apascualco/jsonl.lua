pcall(vim.treesitter.language.register, "json", "jsonl")

local function open_float(lines, title)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].filetype = "json"
	vim.bo[buf].modifiable = false
	vim.bo[buf].bufhidden = "wipe"

	local width = math.min(100, vim.o.columns - 4)
	local height = math.min(#lines, vim.o.lines - 6)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = math.max(height, 1),
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
		title = title and (" " .. title .. " ") or nil,
		title_pos = "center",
	})
	pcall(vim.treesitter.start, buf, "json")
	for _, key in ipairs({ "q", "<Esc>" }) do
		vim.keymap.set("n", key, function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end, { buffer = buf, nowait = true, silent = true })
	end
	return win
end

local function jq_pretty(input)
	if vim.fn.executable("jq") == 0 then
		return nil, "jq no está instalado"
	end
	local out = vim.fn.systemlist({ "jq", "." }, input)
	if vim.v.shell_error ~= 0 then
		return nil, "JSON no válido"
	end
	return out
end

local function preview_record()
	local line = vim.api.nvim_get_current_line()
	if line:match("^%s*$") then
		return
	end
	local lnum = vim.api.nvim_win_get_cursor(0)[1]
	local out, err = jq_pretty(line)
	if not out then
		vim.notify(err .. " (línea " .. lnum .. ")", vim.log.levels.WARN)
		return
	end
	open_float(out, "record L" .. lnum)
end

local function pretty_whole_file()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local out, err = jq_pretty(table.concat(lines, "\n"))
	if not out then
		vim.notify(err, vim.log.levels.ERROR)
		return
	end
	local src = vim.api.nvim_buf_get_name(0)
	vim.cmd("botright vsplit")
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(0, buf)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
	vim.bo[buf].filetype = "json"
	vim.bo[buf].modifiable = false
	vim.bo[buf].bufhidden = "wipe"
	if src ~= "" then
		pcall(vim.api.nvim_buf_set_name, buf, src .. " [pretty]")
	end
	pcall(vim.treesitter.start, buf, "json")
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "jsonl",
	callback = function(args)
		if not (vim.treesitter.highlighter and vim.treesitter.highlighter.active[args.buf]) then
			pcall(vim.treesitter.start, args.buf, "json")
		end
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true

		vim.keymap.set("n", "<leader>jq", preview_record,
			{ buffer = args.buf, desc = "Pretty-print record" })
		vim.api.nvim_buf_create_user_command(args.buf, "JsonlPretty", pretty_whole_file,
			{ desc = "Pretty-print whole file (read-only scratch)" })
	end,
})

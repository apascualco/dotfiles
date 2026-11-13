local augroup = vim.api.nvim_create_augroup

local refresh_group = augroup("RefreshExternalChanges", { clear = true })
local last_refresh = 0

local function refresh_external_changes(args)
	if vim.fn.mode() ~= "n" then
		return
	end
	if args and args.event == "BufEnter" then
		pcall(vim.cmd, "silent! checktime")
		return
	end
	local now = vim.uv.now()
	if (now - last_refresh) < 400 then
		return
	end
	last_refresh = now
	vim.schedule(function()
		if vim.fn.mode() ~= "n" then
			return
		end
		pcall(vim.cmd, "silent! checktime")
		local ok_gitsigns, gitsigns = pcall(require, "gitsigns")
		if ok_gitsigns then
			pcall(gitsigns.refresh)
		end
		local ok_tree, api = pcall(require, "nvim-tree.api")
		if ok_tree and api.tree.is_visible() then
			pcall(api.tree.reload)
		end
	end)
end

vim.api.nvim_create_user_command("RefreshExternalChanges", function()
	refresh_external_changes()
end, { desc = "Refresh files and git UI after external changes" })

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermClose", "TermLeave", "ShellCmdPost" }, {
	group = refresh_group,
	callback = refresh_external_changes,
})

local import_patterns = {
	go = "^import",
	java = "^import%s",
	typescript = "^import%s",
	javascript = "^import%s",
	typescriptreact = "^import%s",
	javascriptreact = "^import%s",
	python = "^import%s",
	rust = "^use%s",
}

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = augroup("ImportFolds", { clear = true }),
	callback = function(args)
		local buf = args.buf
		if vim.b[buf].import_folds_done then
			return
		end
		local ft = vim.bo[buf].filetype
		local pattern = import_patterns[ft]
		if not pattern then
			return
		end
		vim.b[buf].import_folds_done = true
		vim.defer_fn(function()
			if not vim.api.nvim_buf_is_valid(buf) then
				return
			end
			local total = vim.api.nvim_buf_line_count(buf)
			for lnum = 1, math.min(total, 100) do
				local line = vim.fn.getline(lnum)
				local is_import = line:match(pattern) or (ft == "python" and line:match("^from%s"))
				if is_import then
					pcall(vim.cmd, lnum .. "foldclose")
				end
			end
		end, 150)
	end,
})

local function apply_code_actions_silently(bufnr, kind, matches)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients == 0 then
		return
	end
	local params = vim.lsp.util.make_range_params(0, clients[1].offset_encoding or "utf-16")
	params.context = { only = { kind }, diagnostics = {} }
	local results = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 500)
	if not results then
		return
	end
	for _, res in pairs(results) do
		local client = res.client_id and vim.lsp.get_client_by_id(res.client_id)
		for _, action in ipairs(res.result or {}) do
			if matches(action.kind or "", action.title or "") then
				local enc = (client and client.offset_encoding) or "utf-16"
				if action.edit then
					vim.lsp.util.apply_workspace_edit(action.edit, enc)
				end
				if action.command and client then
					client:exec_cmd(action.command, { bufnr = bufnr })
				end
			end
		end
	end
end

local save_phases = {
	{
		kind = "source.fixAll",
		matches = function(kind, title)
			return kind == "source.fixAll.eslint" or kind == "source.fixAll" or title:match("[Ff]ix all")
		end,
	},
	{
		kind = "source.organizeImports",
		matches = function(kind, title)
			return kind:match("^source%.organizeImports") or title:match("[Oo]rganize Imports")
		end,
	},
}

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup("JsTsSilentFixOnSave", { clear = true }),
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
	callback = function(args)
		for _, phase in ipairs(save_phases) do
			apply_code_actions_silently(args.buf, phase.kind, phase.matches)
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup("ClaudeTreeAdd", { clear = true }),
	pattern = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
	callback = function(ev)
		vim.keymap.set(
			"n",
			"<leader>as",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			{ buffer = ev.buf, silent = true, desc = "Add file" }
		)
	end,
})

local function apply_code_actions_silently(bufnr, wanted)
	local params = vim.lsp.util.make_range_params()
	params.context = { only = wanted }
	local results = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 500)
	if not results then return end

	local function run(action, enc)
		if action.edit then vim.lsp.util.apply_workspace_edit(action.edit, enc or "utf-16") end
		if action.command then vim.lsp.buf.execute_command(action.command) end
	end

	for _, res in pairs(results) do
		local enc = (res.client_id and vim.lsp.get_client_by_id(res.client_id) or {}).offset_encoding or "utf-16"
		for _, action in ipairs(res.result or {}) do
			local kind, title = action.kind or "", action.title or ""
			if kind == "source.fixAll.eslint" or kind == "source.fixAll" or title:match("[Ff]ix all") then
				run(action, enc)
			end
		end
	end
	for _, res in pairs(results) do
		local enc = (res.client_id and vim.lsp.get_client_by_id(res.client_id) or {}).offset_encoding or "utf-16"
		for _, action in ipairs(res.result or {}) do
			local kind, title = action.kind or "", action.title or ""
			if kind:match("^source%.organizeImports") or title:match("[Oo]rganize Imports") then
				run(action, enc)
			end
		end
	end
end

local grp_js = vim.api.nvim_create_augroup("JsTsSilentFixOnSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = grp_js,
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
	callback = function(args)
		apply_code_actions_silently(args.buf, { "source.fixAll", "source.organizeImports" })
	end,
})

local grp_lint = vim.api.nvim_create_augroup("LintOnEvents", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
	group = grp_lint,
	callback = function()
		local ok, lint = pcall(require, "lint")
		if ok then lint.try_lint() end
	end,
})

local grp_go = vim.api.nvim_create_augroup("GoFormatOnSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = grp_go,
	pattern = "*.go",
	callback = function(args)
		apply_code_actions_silently(args.buf, { "source.organizeImports" })
		-- Si usas conform.nvim para Go, puedes llamar a conform aquí en lugar de lsp.buf.format
		vim.lsp.buf.format({ async = false, bufnr = args.buf })
	end,
})
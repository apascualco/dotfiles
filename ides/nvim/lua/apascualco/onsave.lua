local function apply_code_actions_silently(bufnr, kind, matches)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients == 0 then return end
	local encoding = clients[1].offset_encoding or "utf-16"
	local params = vim.lsp.util.make_range_params(0, encoding)
	params.context = { only = { kind }, diagnostics = {} }
	local results = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 500)
	if not results then return end

	for _, res in pairs(results) do
		local client = res.client_id and vim.lsp.get_client_by_id(res.client_id)
		for _, action in ipairs(res.result or {}) do
			if matches(action.kind or "", action.title or "") then
				local enc = (client and client.offset_encoding) or "utf-16"
				if action.edit then vim.lsp.util.apply_workspace_edit(action.edit, enc) end
				if action.command and client then
					client:exec_cmd(action.command, { bufnr = bufnr })
				end
			end
		end
	end
end

local phases = {
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

local grp_js = vim.api.nvim_create_augroup("JsTsSilentFixOnSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = grp_js,
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
	callback = function(args)
		for _, phase in ipairs(phases) do
			apply_code_actions_silently(args.buf, phase.kind, phase.matches)
		end
	end,
})

-- Silent code-action fixers on save.
-- Formatting itself (gofumpt/goimports/prettier/stylua/black/rustfmt/...) is handled by
-- conform.nvim (format_on_save in lazy.lua). Here we only run LSP *code actions* that
-- conform cannot: eslint `source.fixAll` + `source.organizeImports` for JS/TS.
-- Go is intentionally NOT here: conform's goimports+gofumpt already format and organize
-- imports, so a Go autocmd would be double work (this was the old GoFormatOnSave).

local function apply_code_actions_silently(bufnr, wanted)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients == 0 then return end
	local encoding = clients[1].offset_encoding or "utf-16"
	local params = vim.lsp.util.make_range_params(0, encoding)
	params.context = { only = wanted }
	local results = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 500)
	if not results then return end

	local function run(action, client)
		local enc = (client and client.offset_encoding) or "utf-16"
		if action.edit then vim.lsp.util.apply_workspace_edit(action.edit, enc) end
		-- vim.lsp.buf.execute_command is deprecated (0.11) → resolve the client and exec_cmd
		if action.command and client then
			client:exec_cmd(action.command, { bufnr = bufnr })
		end
	end

	-- Phase 1: fixAll (eslint). Phase 2: organizeImports. Order matters.
	local phases = {
		function(kind, title)
			return kind == "source.fixAll.eslint" or kind == "source.fixAll" or title:match("[Ff]ix all")
		end,
		function(kind, title)
			return kind:match("^source%.organizeImports") or title:match("[Oo]rganize Imports")
		end,
	}

	for _, matches in ipairs(phases) do
		for _, res in pairs(results) do
			local client = res.client_id and vim.lsp.get_client_by_id(res.client_id)
			for _, action in ipairs(res.result or {}) do
				if matches(action.kind or "", action.title or "") then
					run(action, client)
				end
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

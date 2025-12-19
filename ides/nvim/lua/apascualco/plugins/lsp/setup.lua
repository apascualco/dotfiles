-- Centralized LSP setup: capabilities and on_attach
-- This file provides shared configuration for all LSP servers

local M = {}

-- Build capabilities once, reuse everywhere
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
	capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- Enable folding capabilities (for nvim-ufo if used)
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

M.capabilities = capabilities

-- Universal on_attach function
M.on_attach = function(client, bufnr)
	-- Enable inlay hints if supported (Neovim 0.10+)
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	-- Signature help on cursor hold in insert mode (DISABLED - use ,lK manually)
	-- if client.server_capabilities.signatureHelpProvider then
	-- 	vim.api.nvim_create_autocmd("CursorHoldI", {
	-- 		buffer = bufnr,
	-- 		callback = function()
	-- 			vim.lsp.buf.signature_help()
	-- 		end,
	-- 	})
	-- end

	-- Document highlight on cursor hold
	if client.server_capabilities.documentHighlightProvider then
		local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })
		vim.api.nvim_create_autocmd("CursorHold", {
			group = group,
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = group,
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end
end

return M

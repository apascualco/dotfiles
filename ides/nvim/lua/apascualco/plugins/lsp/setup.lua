local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
	capabilities = cmp_lsp.default_capabilities(capabilities)
end

vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.codelens.enable(true)

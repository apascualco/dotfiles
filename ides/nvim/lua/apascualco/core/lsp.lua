local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
	capabilities = cmp_lsp.default_capabilities(capabilities)
end

vim.lsp.config("*", { capabilities = capabilities })
vim.lsp.codelens.enable(true)

vim.lsp.enable({
	"lua_ls",
	"ts_ls",
	"eslint",
	"html",
	"cssls",
	"jsonls",
	"yamlls",
	"buf_ls",
	"gopls",
	"basedpyright",
	"ruff",
})
vim.lsp.enable({ "jdtls", "rust_analyzer" }, false)

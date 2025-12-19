local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
	capabilities = cmp_lsp.default_capabilities(capabilities)
end

vim.lsp.config("gopls", {
  cmd         = { "gopls" },
  filetypes   = { "go", "gomod", "gowork", "gotmpl" },
  root_markers= { "go.work", "go.mod", ".git" },
  capabilities= capabilities,
  settings    = {
    gopls = {
      completeUnimported           = true,
      gofumpt = true,
      usePlaceholders              = true,
      completeFunctionCalls        = true,
      experimentalPostfixCompletions = true,
      analyses = {
        unusedparams = true,
        shadow = true,
        unusedwrite = true,
        useany = true,
      },
      staticcheck = true,
      codelenses = {
        gc_details = true,
        generate = true,
        regenerate_cgo = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      -- Estas opciones ayudan con los imports
      importShortcut = "Both",
      semanticTokens = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})

vim.lsp.enable("gopls")
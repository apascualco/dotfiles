local lspconfig = require('lspconfig')
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.cssls.setup({
  capabilities = capabilities
})

lspconfig.tailwindcss.setup({
  capabilities = capabilities
})

lspconfig.terraformls.setup({
  capabilities = capabilities
})

lspconfig.ts_ls.setup({
  capabilities = capabilities
})

lspconfig.gradle_ls.setup({
  capabilities = capabilities
})

lspconfig.graphql.setup({
  capabilities = capabilities
})


local lsp_setup = require("apascualco.plugins.lsp.setup")

vim.lsp.config("gopls", {
  on_attach = lsp_setup.on_attach,
  cmd         = { "gopls" },
  filetypes   = { "go", "gomod", "gowork", "gotmpl" },
  root_markers= { "go.work", "go.mod", ".git" },
  capabilities= lsp_setup.capabilities,
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
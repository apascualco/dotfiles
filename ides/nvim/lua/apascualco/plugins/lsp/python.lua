vim.lsp.config("basedpyright", {
  filetypes    = { "python" },
  root_markers = {
    "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt",
    "Pipfile", "pyrightconfig.json", ".git",
  },
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        typeCheckingMode = "standard",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        inlayHints = {
          variableTypes = true,
          functionReturnTypes = true,
          callArgumentNames = true,
        },
      },
    },
  },
})
vim.lsp.enable("basedpyright")

vim.lsp.config("ruff", {
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
  filetypes    = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
})
vim.lsp.enable("ruff")

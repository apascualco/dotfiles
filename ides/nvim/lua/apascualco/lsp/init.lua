require("apascualco.lsp.autocompletion")
require("apascualco.lsp.lua")
require("apascualco.lsp.go")
require("apascualco.lsp.golangci-lint-config")
require("apascualco.lsp.terraform")
require("apascualco.lsp.tsserver")
require("apascualco.lsp.kotlin")

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    local set = vim.keymap.set
    set('n', 'gD', vim.lsp.buf.declaration, { desc = "Go declaration", buffer = ev.buf })
    set('n', 'gd', vim.lsp.buf.definition, { desc = "Go definition",  buffer = ev.buf })
    set('n', 'K', vim.lsp.buf.hover, { desc = "Display information about the symbol under the cursor", buffer = ev.buf })
    set('n', 'gi', vim.lsp.buf.implementation, { desc = "Go implementation", buffer = ev.buf })
    -- leader instead of space
    set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder",  buffer = ev.buf })
    set('n', '<leaser>wr', vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" ,buffer = ev.buf })
    set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { desc = "List workspace folders", buffer = ev.buf })
    set('n', '<leader>D', vim.lsp.buf.type_definition, { desc = "Type definition", buffer = ev.buf })
    set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename", buffer = ev.buf })
    set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = "Code action", buffer = ev.buf })
    set('n', 'gr', vim.lsp.buf.references, { desc = "Show references", buffer = ev.buf })
    set('n', 'gs', vim.lsp.buf.signature_help, { desc = "Signature help", buffer = ev.buf })
    set('n', 'gl', vim.diagnostic.open_float, { desc = "Diagnostic open float", buffer = ev.buf })
    set('n', '[d', vim.diagnostic.goto_prev, { desc = "Diagnostic go to prev" ,buffer = ev.buf })
    set('n', ']d', vim.diagnostic.goto_next, { desc = "Diagnostic go to next", buffer = ev.buf })
    set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, { desc = "Format", buffer = ev.buf })
  end,
})

vim.o.updatetime = 250
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
  callback = function ()
    vim.diagnostic.open_float(nil, {focus=false})
  end
})

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

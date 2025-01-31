local dap = require("dap")

dap.adapters.rt_lldb = {
  type = 'executable',
  command = vim.fn.expand('/opt/homebrew/opt/llvm/bin/lldb-dap'),
  name = 'rt_lldb'
}

dap.adapters.kotlin = {
    type = "executable",
    command = "/Users/apascualco/workdir/tools/kotlin-debug-adapter/adapter/build/install/adapter/bin/kotlin-debug-adapter",
    options = { auto_continue_if_many_stopped = false },
}

dap.configurations.kotlin = {
    {
        type = "kotlin",
        request = "launch",
        name = "This file",
        mainClass = function()
            local root = vim.fs.find("src", { path = vim.uv.cwd(), upward = true, stop = vim.env.HOME })[1] or ""
            local fname = vim.api.nvim_buf_get_name(0)
            return fname:gsub(root, ""):gsub("main/kotlin/", ""):gsub(".kt", "Kt"):gsub("/", "."):sub(2, -1)
        end,
        projectRoot = "${workspaceFolder}",
        jsonLogFile = "",
        enableJsonLogging = false,
    },
    {
        type = "kotlin",
        request = "attach",
        name = "Attach to debugging session",
        port = 5005,
        args = {},
        projectRoot = vim.fn.getcwd,
        hostName = "localhost",
        timeout = 2000,
    },

}
require("nvim-dap-virtual-text").setup {
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    only_first_definition = true,
    all_references = false,
    clear_on_continue = false,
    display_callback = function(variable, buf, stackframe, node, options)
      if options.virt_text_pos == 'inline' then
        return ' = ' .. variable.value
      else
        return variable.name .. ' = ' .. variable.value
      end
    end,
    virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil
}

require("dapui").setup()

local set = vim.keymap.set

set('n', '<Leader>dm', function() require('dapui').open() end, { desc = "Open debugger" })
set('n', '<Leader>dc', function() require('dapui').close() end, { desc = "Close debugger" })
set('n', '<F5>', function() require('dap').continue() end, { desc = "Continue debugger" })
set('n', '<F10>', function() require('dap').step_over() end, { desc = "Step over debugger" })
set('n', '<F11>', function() require('dap').step_into() end, { desc = "Step into debugger" })
set('n', '<F12>', function() require('dap').step_out() end, { desc = "Step our debugger" })
set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end, { desc = "Add/Del breakpoint" })
set('n', '<Leader>B', function() require('dap').set_breakpoint() end, { desc = "Add breakpint" } )
set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = "Add breakpoint with log"})
set('n', '<Leader>dr', function() require('dap').repl.open() end, { desc = "Open repl debugger" })
set('n', '<Leader>dl', function() require('dap').run_last() end)
set({'n', 'v'}, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end, { desc = "Run last debugger" })
set({'n', 'v'}, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end, { desc = "Preview debugger" })
set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end, { desc = "Centered float frames debugger"})
set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end, { desc ="Centered float scopes debugger"})

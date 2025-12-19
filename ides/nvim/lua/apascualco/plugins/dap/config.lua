local dap = require("dap")
local dapUtils = require("dap.utils")

vim.api.nvim_set_hl(
	0,
	"DapStoppedLine",
	{ default = true, link = "DiffChange" } -- using DiffChange so Visual select isn’t same color
)

-- # Sign
local dapSigns =
	{ -- TODO: change highlight for Diagnostic** to have background color
		Stopped = {
			"󰁕 ",
			"DiagnosticSignWarn",
			"DapStoppedLine",
		},
		Breakpoint = { " " },
		BreakpointCondition = { " " },
		BreakpointRejected = { " ", "DiagnosticSignError" },
		LogPoint = { "󰯑 " },
	}

for name, sign in pairs(dapSigns) do
	vim.fn.sign_define("Dap" .. name, {
		text = sign[1],
		texthl = sign[2] or "DiagnosticSignInfo",
		linehl = sign[3],
		numhl = sign[3],
	})
end

-- JS Debug Adapter instalado por Mason
local js_debug_adapter_path = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter"

dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = js_debug_adapter_path,
		args = { "${port}" },
	},
	skipFiles = {
		"<node_internals>/**",
		"**/node_modules/**/*",
	},
}

dap.adapters["pwa-chrome"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = js_debug_adapter_path,
		args = { "${port}" },
	},
}

dap.adapters["chrome"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = js_debug_adapter_path,
		args = { "${port}" },
	},
}

dap.adapters["Electron chrome"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = js_debug_adapter_path,
		args = { "${port}" },
	},
}

for _, language in ipairs({
	"typescript",
	"typescriptreact",
	"javascript",
	"javascriptreact",
}) do
	dap.configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file " .. language,
			program = "${file}",
			cwd = "${workspaceFolder}",
			runtimeExecutable = "tsx",
			-- runtimeArgs = {},
			sourceMaps = true,
			protocol = "inspector",
			skipFiles = {
				"<node_internals>/**",
				"node_modules/**",
			},
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
		},

		{
			type = "pwa-node",
			request = "attach",
			name = "Attach to Process " .. language,
			processId = dapUtils.pick_process,
			cwd = "${workspaceFolder}",
			sourceMaps = true,
		},

		{
			type = "chrome",
			name = "Debug in Chrome",
			request = "launch",
			url = function()
				return coroutine.create(function(dap_run_co)
					vim.ui.input({
						prompt = "Enter URL: ",
						default = "http://localhost:3000",
					}, function(url)
						if url == nil or url == "" then
							url = "http://localhost:3000"
						end

						coroutine.resume(dap_run_co, url)
					end)
				end)
			end,
			cwd = function()
				local rootDirs = vim.fs.find(function(name, path)
					print(name, path)
					return vim.fn.filereadable(
						path .. "/" .. name .. "/package.json"
					) == 1
				end, {
					upward = true,
					type = "directory",
					stop = vim.env.HOME,
					path = vim.fn.expand("%:p:h"),
				})

				if #rootDirs == 0 then
					vim.notify(
						"Couldn't find package.json in the current directory or any parent directory",
						vim.log.levels.ERROR
					)

					print(vim.inspect(rootDirs))
					return "${workspaceFolder}"
				end

				vim.notify(
					"Found package.json at "
					.. rootDirs[1]
					.. " using as cwd for Dap"
				)

				return rootDirs[1]
			end,
			userDataDir = false,
			sourceMaps = true,
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Electron Main (attach :9229)",
			address = "127.0.0.1",
			port = 9229,
			cwd = "${workspaceFolder}",
			sourceMaps = true,
			smartStep = true,
			skipFiles = { "<node_internals>/**", "**/node_modules/**" },
			outFiles = {
				"${workspaceFolder}/out/**/*.js",
				"${workspaceFolder}/dist/**/*.js",
			},

			resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
			trace = true,
			sourceMapPathOverrides = {
				["vite:///*"]      = "${workspaceFolder}/*",
				["webpack:///./*"] = "${workspaceFolder}/*",
				["file:///*"]      = "${workspaceFolder}/*",
				["*/src/*"]        = "${workspaceFolder}/src/*",
				["/src/*"]         = "${workspaceFolder}/src/*",
				["/./*"]           = "${workspaceFolder}/*",
			},
		},

		{
			type = "pwa-chrome",
			request = "attach",
			name = "Electron Renderer (attach :9222)",
			port = 9222,
			webRoot = "${workspaceFolder}",
			sourceMaps = true,
			urlFilter = "http://localhost:5173/*", -- opcional si usas Vite; puedes omitirlo
			trace = true,
			sourceMapPathOverrides = {
				["webpack:///./*"] = "${workspaceFolder}/*",
				["vite:///*"]      = "${workspaceFolder}/*",
				["file:///*"]      = "${workspaceFolder}/*",
			},
		},
	}
end

require('dap').set_log_level('TRACE')
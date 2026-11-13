local dap = require("dap")
local js_debug_adapter = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter"

for _, name in ipairs({ "pwa-node", "pwa-chrome", "chrome", "Electron chrome" }) do
	dap.adapters[name] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = { command = js_debug_adapter, args = { "${port}" } },
	}
end
dap.adapters["pwa-node"].skipFiles = { "<node_internals>/**", "**/node_modules/**/*" }

local function ask_url()
	return coroutine.create(function(co)
		vim.ui.input({ prompt = "Enter URL: ", default = "http://localhost:3000" }, function(url)
			coroutine.resume(co, (url == nil or url == "") and "http://localhost:3000" or url)
		end)
	end)
end

local function package_json_dir()
	local dirs = vim.fs.find(function(name, path)
		return vim.fn.filereadable(path .. "/" .. name .. "/package.json") == 1
	end, { upward = true, type = "directory", stop = vim.env.HOME, path = vim.fn.expand("%:p:h") })
	if #dirs == 0 then
		vim.notify("Couldn't find package.json in the current directory or any parent directory", vim.log.levels.ERROR)
		return "${workspaceFolder}"
	end
	vim.notify("Found package.json at " .. dirs[1] .. " using as cwd for Dap")
	return dirs[1]
end

local source_map_overrides = {
	["vite:///*"] = "${workspaceFolder}/*",
	["webpack:///./*"] = "${workspaceFolder}/*",
	["file:///*"] = "${workspaceFolder}/*",
	["*/src/*"] = "${workspaceFolder}/src/*",
	["/src/*"] = "${workspaceFolder}/src/*",
	["/./*"] = "${workspaceFolder}/*",
}

for _, language in ipairs({ "typescript", "typescriptreact", "javascript", "javascriptreact" }) do
	dap.configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file " .. language,
			program = "${file}",
			cwd = "${workspaceFolder}",
			runtimeExecutable = "tsx",
			sourceMaps = true,
			protocol = "inspector",
			skipFiles = { "<node_internals>/**", "node_modules/**" },
			resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach to Process " .. language,
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
			sourceMaps = true,
		},
		{
			type = "chrome",
			name = "Debug in Chrome",
			request = "launch",
			url = ask_url,
			cwd = package_json_dir,
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
			outFiles = { "${workspaceFolder}/out/**/*.js", "${workspaceFolder}/dist/**/*.js" },
			resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
			trace = true,
			sourceMapPathOverrides = source_map_overrides,
		},
		{
			type = "pwa-chrome",
			request = "attach",
			name = "Electron Renderer (attach :9222)",
			port = 9222,
			webRoot = "${workspaceFolder}",
			sourceMaps = true,
			urlFilter = "http://localhost:5173/*",
			trace = true,
			sourceMapPathOverrides = {
				["webpack:///./*"] = "${workspaceFolder}/*",
				["vite:///*"] = "${workspaceFolder}/*",
				["file:///*"] = "${workspaceFolder}/*",
			},
		},
	}
end

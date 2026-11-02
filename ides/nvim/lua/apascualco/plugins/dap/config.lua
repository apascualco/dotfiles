local dap = require("dap")
local dapUtils = require("dap.utils")

vim.api.nvim_set_hl(
	0,
	"DapStoppedLine",
	{ default = true, link = "DiffChange" }
)

local dapSigns =
{
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
			urlFilter = "http://localhost:5173/*",
			trace = true,
			sourceMapPathOverrides = {
				["webpack:///./*"] = "${workspaceFolder}/*",
				["vite:///*"]      = "${workspaceFolder}/*",
				["file:///*"]      = "${workspaceFolder}/*",
			},
		},
	}
end

require('dap').set_log_level(vim.env.NEOVIM_DAP_LOG_LEVEL or 'WARN')

local codelldb_bin = vim.fn.stdpath("data") .. "/mason/bin/codelldb"

dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = codelldb_bin,
		args = { "--port", "${port}" },
	},
}

local function cargo_executables(build_args, want_test, on_done)
	local cmd = { "cargo", "build", "--message-format=json" }
	vim.list_extend(cmd, build_args or {})
	local spawned = pcall(vim.system, cmd, { text = true }, function(res)
		local exes = {}
		if res.code == 0 then
			for line in (res.stdout or ""):gmatch("[^\n]+") do
				local ok, msg = pcall(vim.json.decode, line)
				if ok and type(msg) == "table" and msg.reason == "compiler-artifact"
					and msg.executable and msg.executable ~= vim.NIL then
					local is_test = msg.profile ~= nil and msg.profile.test == true
					if want_test == is_test then
						table.insert(exes, msg.executable)
					end
				end
			end
		end
		local code, stderr = res.code, res.stderr
		vim.schedule(function()
			if code ~= 0 then
				vim.notify("[rust dap] cargo build falló:\n" .. (stderr or ""), vim.log.levels.ERROR)
			end
			on_done(exes)
		end)
	end)
	if not spawned then
		vim.schedule(function()
			vim.notify("[rust dap] no se pudo ejecutar `cargo` (¿está en el PATH?)", vim.log.levels.ERROR)
			on_done({})
		end)
	end
end

local function rust_program(build_args, want_test)
	return function()
		return coroutine.create(function(dap_co)
			vim.notify("[rust dap] cargo build…", vim.log.levels.INFO)
			cargo_executables(build_args, want_test, function(exes)
				if #exes == 0 then
					vim.notify("[rust dap] no se encontró ningún ejecutable", vim.log.levels.ERROR)
					coroutine.resume(dap_co, dap.ABORT)
				elseif #exes == 1 then
					coroutine.resume(dap_co, exes[1])
				else
					vim.ui.select(exes, {
						prompt = "Binario a depurar:",
						format_item = function(p) return vim.fn.fnamemodify(p, ":t") end,
					}, function(choice)
						coroutine.resume(dap_co, choice or dap.ABORT)
					end)
				end
			end)
		end)
	end
end

dap.configurations.rust = {
	{
		name = "Rust: debug binario (cargo build)",
		type = "codelldb",
		request = "launch",
		program = rust_program({}, false),
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},
	},
	{
		name = "Rust: debug tests (cargo build --tests)",
		type = "codelldb",
		request = "launch",
		program = rust_program({ "--tests" }, true),
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},
	},
	{
		name = "Rust: attach a proceso…",
		type = "codelldb",
		request = "attach",
		pid = dapUtils.pick_process,
		args = {},
	},
}

dap.adapters.go_remote = function(callback, config)
	callback({
		type = "server",
		host = config.host or "127.0.0.1",
		port = config.port or 2345,
	})
end

local function cabt_root()
	return vim.fs.root(0, { "run_debug.sh", ".git" }) or vim.fn.getcwd()
end

local function cabt_wait_listen(name, tries, on_ready, on_fail)
	if tries <= 0 then
		on_fail("debugpy no empezó a escuchar a tiempo")
		return
	end
	vim.system({ "docker", "exec", name, "sh", "-c", "cat /proc/net/tcp 2>/dev/null" },
		{ text = true }, function(res)
			local ready = false
			for line in (res.stdout or ""):gmatch("[^\n]+") do
				local laddr, st = line:match("^%s*%d+:%s+(%S+)%s+%S+%s+(%S+)")
				if laddr and laddr:upper():match(":162E$") and st and st:upper() == "0A" then
					ready = true
					break
				end
			end
			vim.schedule(function()
				if ready then
					on_ready(name)
				else
					vim.defer_fn(function()
						cabt_wait_listen(name, tries - 1, on_ready, on_fail)
					end, 300)
				end
			end)
		end)
end

dap.adapters.python_docker = function(callback, config)
	local root = cabt_root()
	local agent = config.agent or "agente_pokemon_v1"
	local name = "cabt-debug"

	local function fail(msg)
		vim.schedule(function()
			vim.notify("[Docker debug] " .. msg, vim.log.levels.ERROR)
		end)
	end

	local function ready()
		callback({
			type = "server",
			host = "127.0.0.1",
			port = 5678,
			options = { max_retries = 40, initialize_timeout_sec = 30 },
			enrich_config = function(cfg, on_config)
				local final = vim.deepcopy(cfg)
				final.agent = nil
				final.pathMappings = { { localRoot = root, remoteRoot = "/work" } }
				on_config(final)
			end,
		})
	end

	vim.system({ "docker", "rm", "-f", name }, { text = true }, function()
		vim.system({
			"docker", "run", "-d", "--name", name, "--rm",
			"--platform", "linux/amd64",
			"-p", "5678:5678",
			"-v", root .. ":/work",
			"cabt-local",
			"python", "-m", "debugpy",
			"--listen", "0.0.0.0:5678",
			"--wait-for-client",
			"tools/debug_driver.py", agent,
		}, { text = true }, function(run)
			if run.code ~= 0 then
				fail("docker run falló (¿Docker arrancado?): " .. (run.stderr or ""))
				return
			end
			vim.schedule(function()
				vim.notify("[Docker debug] contenedor arrancado; esperando a debugpy…", vim.log.levels.INFO)
				cabt_wait_listen(name, 100, ready, fail)
			end)
		end)
	end)
end

dap.configurations.python = dap.configurations.python or {}
for _, agent in ipairs({ "agente_pokemon_v1", "agente_pokemon_v2" }) do
	table.insert(dap.configurations.python, {
		type = "python_docker",
		request = "attach",
		name = "Docker: depurar " .. agent,
		agent = agent,
		justMyCode = true,
	})
end

local function cabt_cleanup(session)
	if session and session.config and session.config.type == "python_docker" then
		vim.system({ "docker", "rm", "-f", "cabt-debug" })
	end
end
dap.listeners.before.event_terminated["cabt_docker_cleanup"] = cabt_cleanup
dap.listeners.before.event_exited["cabt_docker_cleanup"] = cabt_cleanup


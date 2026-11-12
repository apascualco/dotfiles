local M = {}

local function roots()
	local list = {}
	for _, root in ipairs({ vim.fs.root(0, ".git"), vim.fs.root(0, { "go.work", "go.mod" }) }) do
		if root and not vim.tbl_contains(list, root) then
			table.insert(list, root)
		end
	end
	if #list == 0 then
		list = { vim.fn.getcwd() }
	end
	return list
end

local function find_mains(root)
	local found = vim.fn.systemlist({
		"find",
		root,
		"-type",
		"d",
		"(",
		"-name",
		"vendor",
		"-o",
		"-name",
		"node_modules",
		"-o",
		"-name",
		".git",
		")",
		"-prune",
		"-o",
		"-type",
		"f",
		"-name",
		"main.go",
		"-print",
	})
	if vim.v.shell_error ~= 0 then
		return {}
	end
	table.sort(found)
	return found
end

local function expand(value, root)
	return (value:gsub("%${workspaceFolder}", function()
		return root
	end))
end

local function normalize(path)
	return (vim.fs.normalize(path):gsub("/$", ""))
end

local function launch_env(dir, project_roots)
	for _, root in ipairs(project_roots) do
		for _, rel in ipairs({ "/.vscode/launch.json", "/alberto/launch.json" }) do
			local path = root .. rel
			if vim.fn.filereadable(path) == 1 then
				local ok, json =
					pcall(vim.json.decode, table.concat(vim.fn.readfile(path), "\n"), { skip_comments = true })
				if ok and type(json) == "table" and type(json.configurations) == "table" then
					for _, cfg in ipairs(json.configurations) do
						if
							type(cfg.program) == "string"
							and type(cfg.env) == "table"
							and normalize(expand(cfg.program, root)) == dir
						then
							local env = {}
							for k, v in pairs(cfg.env) do
								env[k] = expand(tostring(v), root)
							end
							if next(env) then
								return env
							end
						end
					end
				end
			end
		end
	end
end

local function parse_env_file(path)
	local env = {}
	for line in io.lines(path) do
		line = line:gsub("^%s*export%s+", "")
		local key, value = line:match("^%s*([%w_]+)%s*=%s*(.*)$")
		if key then
			env[key] = value:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
		end
	end
	return env
end

local function resolve_env(dir, project_roots)
	local env = launch_env(dir, project_roots)
	if env then
		return { vars = env }
	end
	local top = project_roots[1]
	local file = vim.fs.find(".env.local", { upward = true, path = dir, stop = vim.fs.dirname(top) })[1]
	if file then
		return { vars = parse_env_file(file), file = file }
	end
	return { vars = {} }
end

local function with_project_defaults(dir, env)
	local defaults = require("apascualco.lang.go.project").run_defaults(dir)
	if not defaults then
		return env, dir
	end
	env.defaults = defaults.vars
	local warning = defaults.validate and defaults.validate(vim.tbl_extend("force", defaults.vars, env.vars))
	if warning then
		vim.notify(warning, vim.log.levels.WARN)
	end
	return env, defaults.root
end

local function pick(prompt, on_choice)
	local project_roots = roots()
	local top = project_roots[1]
	local mains = find_mains(top)
	if #mains == 0 then
		vim.notify("No main.go found in " .. top, vim.log.levels.WARN)
		return
	end

	local function choose(main)
		local dir = normalize(vim.fs.dirname(main))
		local env, cwd = with_project_defaults(dir, resolve_env(dir, project_roots))
		on_choice(main, dir, env, cwd)
	end

	if #mains == 1 then
		choose(mains[1])
		return
	end
	vim.ui.select(mains, {
		prompt = prompt,
		format_item = function(path)
			return vim.fs.relpath(top, path) or path
		end,
	}, function(choice)
		if choice then
			choose(choice)
		end
	end)
end

function M.env_file(file)
	local project_roots = roots()
	local dir = normalize(vim.fs.dirname(file))
	local found = vim.fs.find(".env.local", { upward = true, path = dir, stop = vim.fs.dirname(project_roots[1]) })[1]
	local warning = launch_env(dir, project_roots)
			and "launch.json ya define variables para este main: tendrán prioridad sobre .env.local"
		or nil
	return found or (dir .. "/.env.local"), warning
end

function M.run()
	pick("Run main.go", function(main, dir, env, cwd)
		local exports = {}
		local inline = vim.tbl_extend("force", env.defaults or {}, env.file and {} or env.vars)
		for k, v in pairs(inline) do
			table.insert(exports, "export " .. k .. "=" .. vim.fn.shellescape(v))
		end
		if env.file then
			table.insert(exports, "set -a && source " .. vim.fn.shellescape(env.file) .. " && set +a")
		end
		local prefix = #exports > 0 and (table.concat(exports, " && ") .. " && ") or ""
		local target = cwd == dir and "." or ("./" .. (vim.fs.relpath(cwd, dir) or "."))

		local terminal = require("toggleterm.terminal")
		local id = vim.fn.len(terminal.get_all()) + 1
		terminal.Terminal
			:new({
				cmd = prefix .. "cd " .. vim.fn.shellescape(cwd) .. " && go run " .. vim.fn.shellescape(target),
				direction = "horizontal",
				close_on_exit = false,
				count = id,
				on_exit = function(_, _, code)
					local level = code == 0 and vim.log.levels.INFO or vim.log.levels.WARN
					vim.notify("Go run [" .. id .. "] exited with code " .. code, level)
				end,
			})
			:toggle()
		vim.notify("Terminal " .. id .. " running: " .. main)
	end)
end

function M.debug()
	pick("Debug main.go", function(_, dir, env, cwd)
		local vars = vim.tbl_extend("force", env.defaults or {}, env.vars)
		require("lazy").load({ plugins = { "nvim-dap-go" } })
		require("dap").run({
			type = "go",
			name = "Debug " .. vim.fs.basename(dir),
			request = "launch",
			mode = "debug",
			program = dir,
			cwd = cwd,
			env = next(vars) and vars or vim.empty_dict(),
			console = "integratedTerminal",
		})
	end)
end

return M

local M = {}

local markers = {
	"pyproject.toml",
	"setup.py",
	"setup.cfg",
	"requirements.txt",
	"Pipfile",
	"uv.lock",
	"poetry.lock",
	".venv",
	"venv",
}

local tasks = {
	install = { uv = "sync", poetry = "install", pipenv = "install", pip = "install" },
	add = { uv = "add", poetry = "add", pipenv = "install", pip = "install" },
	remove = { uv = "remove", poetry = "remove", pipenv = "uninstall", pip = "uninstall -y" },
	update = { uv = "sync --upgrade", poetry = "update", pipenv = "update", pip = "install -U" },
	list = { uv = "pip list", poetry = "show", pipenv = "graph", pip = "list" },
	venv = { uv = "venv", poetry = "env use python3", pipenv = "--python 3" },
}

local function has(root, name)
	return root ~= nil and vim.uv.fs_stat(root .. "/" .. name) ~= nil
end

function M.root(bufnr)
	local root = vim.fs.root(bufnr or 0, markers)
	if root == nil or root == vim.uv.os_homedir() then
		return nil
	end
	return root
end

local function project_root()
	local file = vim.api.nvim_buf_get_name(0)
	return M.root() or (file ~= "" and vim.fs.dirname(file)) or vim.fn.getcwd()
end

function M.manager(root)
	if has(root, "uv.lock") then
		return "uv"
	end
	if has(root, "poetry.lock") then
		return "poetry"
	end
	if has(root, "Pipfile") then
		return "pipenv"
	end
	return "pip"
end

local function managed_env(root, manager)
	if vim.fn.executable(manager) == 0 then
		return nil
	end
	local cmd = manager == "poetry" and { "poetry", "env", "info", "-p" } or { "pipenv", "--venv" }
	local res = vim.system(cmd, { cwd = root, text = true }):wait(10000)
	local env = res.code == 0 and vim.trim(res.stdout or "") or ""
	if env ~= "" and vim.uv.fs_stat(env .. "/bin/python") then
		return env .. "/bin/python"
	end
end

function M.python_path(root)
	root = root or project_root()
	if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
		return vim.env.VIRTUAL_ENV .. "/bin/python"
	end
	for _, dir in ipairs({ ".venv", "venv" }) do
		local candidate = root .. "/" .. dir .. "/bin/python"
		if vim.uv.fs_stat(candidate) then
			return candidate
		end
	end
	local manager = M.manager(root)
	if manager == "poetry" or manager == "pipenv" then
		local python = managed_env(root, manager)
		if python then
			return python
		end
	end
	local system = vim.fn.exepath("python3")
	return system ~= "" and system or "python3"
end

function M.module_target(file)
	local dir = vim.fs.dirname(file)
	if not vim.uv.fs_stat(dir .. "/__init__.py") then
		return nil
	end
	local parts = { vim.fn.fnamemodify(file, ":t:r") }
	local top = dir
	while vim.uv.fs_stat(top .. "/__init__.py") do
		table.insert(parts, 1, vim.fs.basename(top))
		top = vim.fs.dirname(top)
	end
	return table.concat(parts, "."), top
end

function M.run_file()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		return
	end
	local root = project_root()
	local python = vim.fn.shellescape(M.python_path(root))
	local module, cwd = M.module_target(file)
	local runner = require("apascualco.util.runner")
	if module then
		runner.run(cwd, runner.join({ python, "-m", module }))
	else
		runner.run(root, runner.join({ python, vim.fn.shellescape(file) }))
	end
end

function M.debug_file()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		return
	end
	local root = project_root()
	local module, cwd = M.module_target(file)
	require("lazy").load({ plugins = { "nvim-dap-python" } })
	local config = {
		type = "python",
		request = "launch",
		name = "Debug " .. vim.fs.basename(file),
		cwd = module and cwd or root,
		console = "integratedTerminal",
		justMyCode = false,
		pythonPath = M.python_path(root),
	}
	if module then
		config.module = module
	else
		config.program = file
	end
	require("dap").run(config)
end

function M.tool(args, prompt)
	local root = project_root()
	local runner = require("apascualco.util.runner")
	runner.with_input(prompt, function(extra)
		runner.run(root, runner.join({ vim.fn.shellescape(M.python_path(root)), args, extra }))
	end)
end

function M.repl()
	local root = project_root()
	local python = M.python_path(root)
	local ipython = vim.fs.dirname(python) .. "/ipython"
	local cmd = vim.uv.fs_stat(ipython) and ipython or python
	require("apascualco.util.runner").run(root, vim.fn.shellescape(cmd))
end

function M.ruff(args)
	local root = project_root()
	local ruff = vim.fn.exepath("ruff")
	local bin = ruff ~= "" and vim.fn.shellescape(ruff) or (vim.fn.shellescape(M.python_path(root)) .. " -m ruff")
	local runner = require("apascualco.util.runner")
	runner.run(root, runner.join({ bin, args }))
end

function M.typecheck()
	local bin = vim.fn.exepath("basedpyright")
	if bin == "" then
		vim.notify("basedpyright is not installed (Mason)", vim.log.levels.ERROR)
		return
	end
	require("apascualco.util.runner").run(project_root(), vim.fn.shellescape(bin))
end

local function pip_target(root, task)
	if task == "install" or task == "update" then
		if has(root, "requirements.txt") then
			return "-r requirements.txt"
		end
		if has(root, "pyproject.toml") then
			return "-e ."
		end
	end
end

function M.manage(task, prompt)
	local root = project_root()
	local manager = M.manager(root)
	local bin = manager
	if manager == "pip" then
		if task == "venv" then
			require("apascualco.util.runner").run(root, "python3 -m venv .venv")
			return
		end
		bin = vim.fn.shellescape(M.python_path(root)) .. " -m pip"
	elseif vim.fn.executable(manager) == 0 then
		vim.notify(manager .. " is not on the PATH", vim.log.levels.ERROR)
		return
	end
	local args = tasks[task] and tasks[task][manager] or task
	local runner = require("apascualco.util.runner")
	runner.with_input(prompt, function(extra)
		runner.run(root, runner.join({ bin, args, manager == "pip" and pip_target(root, task) or nil, extra }))
	end)
end

return M

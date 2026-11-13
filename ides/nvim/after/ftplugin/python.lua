local lang = require("apascualco.lang")
local project = require("apascualco.lang.python.project")
local buf = vim.api.nvim_get_current_buf()

local function ruff(args)
	return function()
		project.ruff(args)
	end
end

local function manage(task, prompt)
	return function()
		project.manage(task, prompt)
	end
end

lang.setup(buf, {
	run = { project.run_file, "Run file" },
	debug = { project.debug_file, "Debug file" },
	debug_selection = {
		function()
			require("dap-python").debug_selection()
		end,
		"Debug selection",
		mode = "x",
	},
	organize_imports = {
		function()
			lang.code_action({ "source.organizeImports", "source.organizeImports.ruff" })
		end,
		"Organize imports (ruff)",
	},
	add_import = lang.add_import,
	format = { ruff("format ."), "ruff format (project)" },
	lint = { ruff("check ."), "ruff check" },
	lint_fix = { ruff("check --fix ."), "ruff check --fix" },
	typecheck = { project.typecheck, "basedpyright (project)" },
	repl = { project.repl, "REPL (venv)" },
	tests = {
		all = {
			function()
				local dir = vim.fn.expand("%:p:h")
				lang.neotest_run(dir, { dir })
			end,
			"Test directory",
		},
		coverage = {
			function()
				project.tool("-m pytest --cov --cov-report=term-missing")
			end,
			"Coverage (pytest-cov)",
		},
	},
	generate = {
		x = {
			function()
				lang.code_action({ "source.fixAll", "source.fixAll.ruff" })
			end,
			"Fix all (ruff)",
		},
	},
	packages = {
		install = { manage("install"), "Install dependencies" },
		add = { manage("add", "package: "), "Add package" },
		remove = { manage("remove", "package: "), "Remove package" },
		update = { manage("update"), "Update dependencies" },
		list = { manage("list"), "List packages" },
		init = { manage("venv"), "Create venv" },
		args = { manage("", "uv/poetry/pipenv/pip args: "), "Package manager with args" },
	},
})

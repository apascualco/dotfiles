local M = {}

local actions = {
	run = { "<leader>pr", "Run" },
	debug = { "<leader>pd", "Debug" },
	debug_selection = { "<leader>pd", "Debug selection" },
	build = { "<leader>pb", "Build" },
	build_release = { "<leader>pB", "Build release / package" },
	organize_imports = { "<leader>po", "Organize imports" },
	add_import = { "<leader>pq", "Add missing import" },
	format = { "<leader>pf", "Format project" },
	lint = { "<leader>pk", "Lint project" },
	lint_fix = { "<leader>pK", "Lint and fix project" },
	typecheck = { "<leader>py", "Type check project" },
	repl = { "<leader>pi", "REPL" },
	docs = { "<leader>ph", "Docs for symbol" },
	super = { "<leader>pu", "Super implementation" },
	runtime = { "<leader>pR", "Select runtime" },
}

local tests = {
	nearest = { "<leader>nn", "Run nearest" },
	file = { "<leader>nf", "Run file" },
	all = { "<leader>na", "Run all (package)" },
	last = { "<leader>nl", "Run last" },
	debug = { "<leader>nd", "Debug nearest" },
	coverage = { "<leader>nc", "Coverage" },
	pick = { "<leader>np", "Pick test" },
}

local packages = {
	install = { "<leader>Pi", "Install dependencies" },
	add = { "<leader>Pa", "Add package" },
	remove = { "<leader>Pr", "Remove package" },
	update = { "<leader>Pu", "Update dependencies" },
	tidy = { "<leader>Pt", "Tidy dependencies" },
	clean = { "<leader>Pc", "Clean build artifacts" },
	list = { "<leader>Pl", "List dependencies" },
	vendor = { "<leader>Pv", "Vendor dependencies" },
	init = { "<leader>Pn", "Init project / environment" },
	generate = { "<leader>Pg", "Run code generators" },
	docs = { "<leader>Pd", "Build and open docs" },
	package = { "<leader>Pp", "Package artifact" },
	install_local = { "<leader>PI", "Install to local repository" },
	sync = { "<leader>Ps", "Resync project config" },
	args = { "<leader>Px", "Tool with arguments" },
}

local function bind(bufnr, keys, spec)
	for name, impl in pairs(spec or {}) do
		local key = keys[name]
		if key then
			local rhs, desc, mode = impl, key[2], "n"
			if type(impl) == "table" then
				rhs, desc, mode = impl[1], impl[2] or key[2], impl.mode or "n"
			end
			vim.keymap.set(mode, key[1], rhs, { buffer = bufnr, silent = true, desc = desc })
		end
	end
end

function M.setup(bufnr, spec)
	bind(bufnr, actions, spec)
	bind(bufnr, tests, spec.tests)
	bind(bufnr, packages, spec.packages)
	for suffix, impl in pairs(spec.generate or {}) do
		vim.keymap.set(
			impl.mode or "n",
			"<leader>pg" .. suffix,
			impl[1],
			{ buffer = bufnr, silent = true, desc = impl[2] }
		)
	end
end

function M.neotest_args(path, args)
	if vim.bo.filetype == "go" then
		return require("apascualco.lang.go.project").neotest_args(path, args)
	end
	return args or {}
end

function M.neotest_run(path, args)
	local resolved = M.neotest_args(path, args)
	if resolved then
		require("neotest").run.run(resolved)
	end
end

function M.code_action(kinds, filter)
	vim.lsp.buf.code_action({ context = { only = kinds, diagnostics = {} }, filter = filter, apply = true })
end

function M.organize_imports()
	M.code_action({ "source.organizeImports" })
end

function M.add_import()
	M.code_action({ "quickfix" }, function(action)
		return (action.title or ""):lower():find("import", 1, true) ~= nil
	end)
end

return M

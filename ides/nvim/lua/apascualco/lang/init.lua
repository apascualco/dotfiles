local M = {}

local actions = {
	run = { "<leader>kr", "Run" },
	debug = { "<leader>kd", "Debug" },
	debug_selection = { "<leader>kd", "Debug selection" },
	build = { "<leader>kb", "Build" },
	build_release = { "<leader>kB", "Build release / package" },
	organize_imports = { "<leader>ko", "Organize imports" },
	add_import = { "<leader>kq", "Add missing import" },
	format = { "<leader>kf", "Format project" },
	lint = { "<leader>kk", "Lint project" },
	lint_fix = { "<leader>kK", "Lint and fix project" },
	typecheck = { "<leader>ky", "Type check project" },
	repl = { "<leader>ki", "REPL" },
	docs = { "<leader>kh", "Docs for symbol" },
	super = { "<leader>ku", "Super implementation" },
	runtime = { "<leader>kR", "Select runtime" },
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
	install = { "<leader>Ki", "Install dependencies" },
	add = { "<leader>Ka", "Add package" },
	remove = { "<leader>Kr", "Remove package" },
	update = { "<leader>Ku", "Update dependencies" },
	tidy = { "<leader>Kt", "Tidy dependencies" },
	clean = { "<leader>Kc", "Clean build artifacts" },
	list = { "<leader>Kl", "List dependencies" },
	vendor = { "<leader>Kv", "Vendor dependencies" },
	init = { "<leader>Kn", "Init project / environment" },
	generate = { "<leader>Kg", "Run code generators" },
	docs = { "<leader>Kd", "Build and open docs" },
	package = { "<leader>Kp", "Package artifact" },
	install_local = { "<leader>KI", "Install to local repository" },
	sync = { "<leader>Ks", "Resync project config" },
	args = { "<leader>Kx", "Tool with arguments" },
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
			"<leader>G" .. suffix,
			impl[1],
			{ buffer = bufnr, silent = true, desc = impl[2] }
		)
	end
end

local generate_keys = { "A", "E", "M", "R", "V", "c", "e", "f", "g", "h", "i", "j", "m", "o", "p", "s", "v", "x", "y" }

local function unavailable(desc)
	return function()
		local ft = vim.bo.filetype ~= "" and vim.bo.filetype or "este buffer"
		vim.notify(desc .. ": no disponible en " .. ft, vim.log.levels.INFO)
	end
end

local function fallback(mode, lhs, desc)
	if next(vim.fn.maparg(lhs, mode, false, true)) == nil then
		vim.keymap.set(mode, lhs, unavailable(desc), { silent = true, desc = "which_key_ignore" })
	end
end

function M.register_fallbacks()
	for _, keys in ipairs({ actions, tests, packages }) do
		for _, key in pairs(keys) do
			fallback("n", key[1], key[2])
		end
	end
	fallback("x", actions.debug_selection[1], actions.debug_selection[2])
	for _, suffix in ipairs(generate_keys) do
		fallback("n", "<leader>G" .. suffix, "Generate / refactor")
	end
	for _, suffix in ipairs({ "c", "m", "v" }) do
		fallback("x", "<leader>G" .. suffix, "Extract")
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

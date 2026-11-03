local dap = require("dap")
local dapUtils = require("dap.utils")

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
				if
					ok
					and type(msg) == "table"
					and msg.reason == "compiler-artifact"
					and msg.executable
					and msg.executable ~= vim.NIL
				then
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
						format_item = function(p)
							return vim.fn.fnamemodify(p, ":t")
						end,
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

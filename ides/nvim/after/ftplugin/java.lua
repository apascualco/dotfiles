local buf = vim.api.nvim_get_current_buf()
require("apascualco.lang.java.jdtls").attach(buf)

local lang = require("apascualco.lang")
local main = require("apascualco.lang.java.main")
local build = require("apascualco.lang.java.build")

local function jdtls(name, ...)
	local args = { ... }
	return function()
		require("jdtls")[name](unpack(args))
	end
end

local function tool(task, prompt)
	return function()
		build.run(task, prompt)
	end
end

lang.setup(buf, {
	run = { main.run, "Run main class" },
	debug = { main.debug, "Debug main class" },
	build = { tool("build"), "mvn compile / gradle classes" },
	build_release = { tool("package"), "mvn package / gradle assemble" },
	organize_imports = { jdtls("organize_imports"), "Organize imports" },
	add_import = lang.add_import,
	repl = { jdtls("jshell"), "JShell" },
	super = { jdtls("super_implementation"), "Go to super implementation" },
	runtime = { jdtls("set_runtime"), "Set JDK runtime" },
	tests = {
		nearest = { jdtls("test_nearest_method"), "Run nearest test (JUnit, DAP)" },
		file = { jdtls("test_class"), "Run test class" },
		pick = { jdtls("pick_test"), "Pick test" },
		debug = { jdtls("test_nearest_method"), "Debug nearest test" },
		last = {
			function()
				require("dap").run_last()
			end,
			"Rerun last test",
		},
		all = { tool("test"), "mvn test / gradle test" },
	},
	generate = {
		g = {
			function()
				vim.lsp.buf.code_action({ context = { only = { "source.generate" }, diagnostics = {} } })
			end,
			"Generate toString / equals / constructors",
		},
		v = { jdtls("extract_variable"), "Extract variable" },
		V = { jdtls("extract_variable_all"), "Extract variable (all occurrences)" },
		c = { jdtls("extract_constant"), "Extract constant" },
	},
	packages = {
		install = { tool("install"), "Resolve dependencies" },
		update = { tool("update"), "Refresh dependencies" },
		list = { tool("list"), "Dependency tree" },
		clean = { tool("clean"), "Clean" },
		package = { tool("package"), "Package (skip tests)" },
		install_local = { tool("install_local"), "Install to local repository" },
		sync = { jdtls("update_project_config"), "Resync project config (jdtls)" },
		args = { tool("", "mvn/gradle args: "), "Build tool with args" },
	},
})

for lhs, rhs in pairs({
	v = { "extract_variable", "Extract variable" },
	c = { "extract_constant", "Extract constant" },
	m = { "extract_method", "Extract method" },
}) do
	vim.keymap.set(
		"x",
		"<leader>pg" .. lhs,
		"<Esc><Cmd>lua require('jdtls')." .. rhs[1] .. "(true)<CR>",
		{ buffer = buf, silent = true, desc = rhs[2] }
	)
end

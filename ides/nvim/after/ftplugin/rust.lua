local lang = require("apascualco.lang")
local cargo = require("apascualco.lang.rust.cargo")
local buf = vim.api.nvim_get_current_buf()

local function run(args, prompt)
	return function()
		cargo.run(args, prompt)
	end
end

lang.setup(buf, {
	run = { "<cmd>RustLsp runnables<CR>", "Run (runnables)" },
	debug = { "<cmd>RustLsp debuggables<CR>", "Debug (debuggables)" },
	build = { run("build"), "cargo build" },
	build_release = { run("build --release"), "cargo build --release" },
	add_import = lang.add_import,
	format = { run("fmt"), "cargo fmt" },
	lint = { run("clippy --all-targets"), "cargo clippy" },
	docs = { "<cmd>RustLsp openDocs<CR>", "Open docs.rs" },
	tests = {
		all = { run("test"), "cargo test (crate)" },
	},
	generate = {
		e = { "<cmd>RustLsp expandMacro<CR>", "Expand macro" },
		x = { "<cmd>RustLsp explainError<CR>", "Explain error" },
		E = { "<cmd>RustLsp renderDiagnostic<CR>", "Render diagnostic" },
		j = { "<cmd>RustLsp joinLines<CR>", "Join lines" },
		m = { "<cmd>RustLsp moveItem up<CR>", "Move item up" },
		M = { "<cmd>RustLsp moveItem down<CR>", "Move item down" },
		p = { "<cmd>RustLsp parentModule<CR>", "Parent module" },
		o = { "<cmd>RustLsp openCargo<CR>", "Open Cargo.toml" },
		h = { "<cmd>RustLsp hover actions<CR>", "Hover actions" },
		s = { "<cmd>RustLsp ssr<CR>", "Structural search replace" },
	},
	packages = {
		install = { run("fetch"), "cargo fetch" },
		add = { run("add", "cargo add: "), "cargo add" },
		remove = { run("remove", "cargo remove: "), "cargo remove" },
		update = { run("update"), "cargo update" },
		clean = { run("clean"), "cargo clean" },
		list = { run("tree"), "cargo tree" },
		vendor = { run("vendor"), "cargo vendor" },
		init = { run("init"), "cargo init" },
		docs = { run("doc --open"), "cargo doc --open" },
		args = { run("", "cargo args: "), "cargo <args>" },
	},
})

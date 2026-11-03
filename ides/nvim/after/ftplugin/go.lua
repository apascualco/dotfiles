local lang = require("apascualco.lang")
local main = require("apascualco.lang.go.main")
local project = require("apascualco.lang.go.project")
local runner = require("apascualco.util.runner")
local buf = vim.api.nvim_get_current_buf()

local function root()
	return vim.fs.root(0, { "go.work", "go.mod" }) or vim.fn.getcwd()
end

local function go(args, prompt)
	runner.with_input(prompt, function(extra)
		runner.run(root(), runner.join({ "go", args, extra }))
	end)
end

local function coverage()
	local env = project.test_env(vim.api.nvim_buf_get_name(0)) or {}
	local saved = {}
	for k, v in pairs(env) do
		saved[k] = vim.env[k]
		vim.env[k] = v
	end
	vim.cmd("GoCoverage")
	for k in pairs(env) do
		vim.env[k] = saved[k]
	end
end

lang.setup(buf, {
	run = { main.run, "Run main.go" },
	debug = { main.debug, "Debug main.go" },
	build = {
		function()
			runner.run(vim.fn.expand("%:p:h"), "go build .")
		end,
		"go build (package)",
	},
	organize_imports = lang.organize_imports,
	add_import = lang.add_import,
	lint = {
		function()
			runner.run(root(), vim.fn.executable("golangci-lint") == 1 and "golangci-lint run ./..." or "go vet ./...")
		end,
		"golangci-lint / go vet",
	},
	docs = { "<cmd>GoDoc<CR>", "Go doc" },
	tests = {
		all = {
			function()
				local dir = vim.fn.expand("%:p:h")
				lang.neotest_run(dir, { dir })
			end,
			"Test package",
		},
		coverage = { coverage, "Coverage (GoCoverage)" },
	},
	generate = {
		j = { "<cmd>GoTagAdd json<CR>", "Add json tags" },
		y = { "<cmd>GoTagAdd yaml<CR>", "Add yaml tags" },
		A = {
			function()
				vim.cmd("GoTagAdd json")
				vim.cmd("GoTagAdd yaml")
			end,
			"Add json + yaml tags",
		},
		R = { "<cmd>GoTagRm<CR>", "Remove tags" },
		e = { "<cmd>GoIfErr<CR>", "Insert if err" },
		i = { "<cmd>GoImpl<CR>", "Implement interface" },
		f = { "<cmd>GoFillStruct<CR>", "Fill struct" },
		s = { "<cmd>GoFillSwitch<CR>", "Fill switch" },
		m = { "<cmd>GoMockGen<CR>", "Generate mock" },
	},
	packages = {
		install = {
			function()
				go("mod download")
			end,
			"go mod download",
		},
		add = {
			function()
				go("get", "go get: ")
			end,
			"go get",
		},
		remove = {
			function()
				runner.with_input("go get <pkg>@none, package: ", function(pkg)
					if pkg ~= "" then
						runner.run(root(), "go get " .. pkg .. "@none")
					end
				end)
			end,
			"go get <pkg>@none",
		},
		update = {
			function()
				go("get -u ./...")
			end,
			"go get -u ./...",
		},
		tidy = {
			function()
				go("mod tidy")
			end,
			"go mod tidy",
		},
		clean = {
			function()
				go("clean")
			end,
			"go clean",
		},
		list = {
			function()
				go("list -m all")
			end,
			"go list -m all",
		},
		vendor = {
			function()
				go("mod vendor")
			end,
			"go mod vendor",
		},
		init = {
			function()
				go("mod init", "Module name: ")
			end,
			"go mod init",
		},
		generate = {
			function()
				go("generate ./...")
			end,
			"go generate ./...",
		},
		args = {
			function()
				go("", "go args: ")
			end,
			"go <args>",
		},
	},
})

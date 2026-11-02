local uv = vim.uv or vim.loop

local function load_profile()
	local path = uv.os_homedir() .. "/.local_nvim_go.lua"
	if not uv.fs_stat(path) then
		return {}
	end
	local ok, profile = pcall(dofile, path)
	if ok and type(profile) == "table" then
		return profile
	end
	vim.schedule(function()
		vim.notify("goproject: no se pudo cargar " .. path .. "\n" .. tostring(profile), vim.log.levels.ERROR)
	end)
	return {}
end

local profile = load_profile()

local M = {}

local last_test_path

function M.go_formatters(bufnr)
	if profile.go_formatters then
		return profile.go_formatters(bufnr)
	end
	return { "goimports", "gofumpt" }
end

function M.gopls_settings(root)
	if profile.gopls_settings then
		return profile.gopls_settings(root)
	end
end

function M.test_env(path)
	if profile.test_env then
		return profile.test_env(path)
	end
	return {}
end

function M.neotest_args(path, args)
	last_test_path = path
	M.dap_go_opts.delve.build_flags = M.build_flags(path)
	if profile.neotest_args then
		return profile.neotest_args(path, args)
	end
	return args or {}
end

function M.run_defaults(dir)
	if profile.run_defaults then
		return profile.run_defaults(dir)
	end
end

local builtin_constraints = {}
for _, name in ipairs({
	"aix", "android", "darwin", "dragonfly", "freebsd", "hurd", "illumos", "ios", "js", "linux", "nacl",
	"netbsd", "openbsd", "plan9", "solaris", "wasip1", "windows", "zos", "unix",
	"386", "amd64", "arm", "arm64", "loong64", "mips", "mipsle", "mips64", "mips64le", "ppc64", "ppc64le",
	"riscv64", "s390x", "wasm", "cgo", "gc", "gccgo", "ignore",
}) do
	builtin_constraints[name] = true
end

local function tags_in_file(path, tags, seen)
	local file = io.open(path, "r")
	if not file then
		return
	end
	for _ = 1, 50 do
		local line = file:read("l")
		if not line or line:match("^package%s") then
			break
		end
		local expr = line:match("^//go:build%s+(.+)$")
		if expr then
			for negated, name in expr:gmatch("(!?)([%w_%.]+)") do
				if negated == "" and not builtin_constraints[name] and not name:match("^go1%.%d+$") and not seen[name] then
					seen[name] = true
					table.insert(tags, name)
				end
			end
		end
	end
	file:close()
end

function M.build_tags(path)
	local tags, seen = {}, {}
	if path and path ~= "" then
		if vim.fn.isdirectory(path) == 1 then
			for _, file in ipairs(vim.fn.glob(path .. "/*_test.go", true, true)) do
				tags_in_file(file, tags, seen)
			end
		else
			tags_in_file(path, tags, seen)
		end
	end
	table.sort(tags)
	return tags
end

function M.build_flags(path)
	local tags = M.build_tags(path)
	if #tags == 0 then
		return nil
	end
	return "-tags=" .. table.concat(tags, ",")
end

M.dap_go_opts = { delve = {} }

function M.go_test_args()
	local args = { "-v", "-race", "-count=1" }
	local flags = M.build_flags(last_test_path or vim.api.nvim_buf_get_name(0))
	if flags then
		table.insert(args, flags)
	end
	return args
end

function M.go_list_args()
	local flags = M.build_flags(last_test_path or vim.api.nvim_buf_get_name(0))
	return flags and { flags } or {}
end

return M

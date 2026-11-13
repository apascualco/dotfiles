local uv = vim.uv or vim.loop
local mason = vim.fn.stdpath("data") .. "/mason"
local sdkman = uv.os_homedir() .. "/.sdkman/candidates/java"

local function version_of(name)
	local major, minor, patch = name:match("^(%d+)%.?(%d*)%.?(%d*)")
	if not major then
		return nil
	end
	return { tonumber(major), tonumber(minor) or 0, tonumber(patch) or 0 }
end

local function newer(a, b)
	for i = 1, 3 do
		if a[i] ~= b[i] then
			return a[i] > b[i]
		end
	end
	return false
end

local function sdkman_jdks()
	local jdks = {}
	if not uv.fs_stat(sdkman) then
		return jdks
	end
	for name, kind in vim.fs.dir(sdkman) do
		local version = kind ~= "file" and name ~= "current" and version_of(name)
		if version then
			table.insert(jdks, { path = sdkman .. "/" .. name, version = version })
		end
	end
	table.sort(jdks, function(a, b)
		return newer(a.version, b.version)
	end)
	return jdks
end

local function default_major()
	local current = uv.fs_realpath(sdkman .. "/current")
	local version = current and version_of(vim.fs.basename(current))
	return version and version[1]
end

local function runtimes(jdks)
	local default = default_major()
	local seen, list = {}, {}
	for _, jdk in ipairs(jdks) do
		local major = jdk.version[1]
		local name = "JavaSE-" .. (major == 8 and "1.8" or tostring(major))
		if not seen[name] then
			seen[name] = true
			table.insert(list, { name = name, path = jdk.path, default = major == default or nil })
		end
	end
	return list
end

local function launcher_jdk(jdks)
	for _, jdk in ipairs(jdks) do
		if jdk.version[1] >= 21 then
			return jdk.path
		end
	end
	return vim.env.JAVA_HOME
end

local function bundles()
	local jars = {}
	local patterns = {
		mason .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
		mason .. "/packages/java-test/extension/server/*.jar",
	}
	for _, pattern in ipairs(patterns) do
		for _, jar in ipairs(vim.split(vim.fn.glob(pattern, true), "\n", { trimempty = true })) do
			local name = vim.fs.basename(jar)
			local shipped = uv.fs_stat(mason .. "/packages/jdtls/plugins/" .. name) ~= nil
			if not shipped and not name:match("^com%.microsoft%.java%.test%.runner") and name ~= "jacocoagent.jar" then
				table.insert(jars, jar)
			end
		end
	end
	return jars
end

local function root_dir(bufnr)
	local home = uv.os_homedir()
	local root = vim.fs.root(bufnr, { "mvnw", "gradlew", "settings.gradle", "settings.gradle.kts", ".git" })
	if root == home then
		root = nil
	end
	root = root or vim.fs.root(bufnr, { "pom.xml", "build.gradle", "build.gradle.kts", "build.xml" })
	return root or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
end

local function workspace_dir(root)
	local name = vim.fs.basename(root) .. "-" .. vim.fn.sha256(root):sub(1, 8)
	return vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. name
end

local function capabilities()
	local caps = vim.lsp.protocol.make_client_capabilities()
	local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
	return ok and cmp_lsp.default_capabilities(caps) or caps
end

local function config(bufnr)
	local jdks = sdkman_jdks()
	local root = root_dir(bufnr)
	return {
		cmd = {
			mason .. "/bin/jdtls",
			"-data",
			workspace_dir(root),
			"--jvm-arg=-javaagent:" .. mason .. "/packages/jdtls/lombok.jar",
		},
		cmd_env = { JAVA_HOME = launcher_jdk(jdks) },
		root_dir = root,
		capabilities = capabilities(),
		init_options = { bundles = bundles() },
		settings = {
			java = {
				configuration = {
					runtimes = runtimes(jdks),
					updateBuildConfiguration = "automatic",
				},
				eclipse = { downloadSources = true },
				maven = { downloadSources = true },
				signatureHelp = { enabled = true },
				inlayHints = { parameterNames = { enabled = "all" } },
				completion = {
					favoriteStaticMembers = {
						"org.junit.Assert.*",
						"org.junit.jupiter.api.Assertions.*",
						"org.mockito.Mockito.*",
					},
				},
				sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
			},
		},
	}
end

local M = {}

function M.attach(bufnr)
	require("jdtls").start_or_attach(config(bufnr), { dap = { hotcodereplace = "auto" } }, { bufnr = bufnr })
end

return M

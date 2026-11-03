local M = {}

local markers =
	{ "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", "settings.gradle.kts" }

local tasks = {
	build = { maven = "compile", gradle = "classes" },
	test = { maven = "test", gradle = "test" },
	package = { maven = "package -DskipTests", gradle = "assemble" },
	install_local = { maven = "install -DskipTests", gradle = "publishToMavenLocal" },
	install = { maven = "dependency:resolve", gradle = "dependencies" },
	update = { maven = "dependency:resolve -U", gradle = "dependencies --refresh-dependencies" },
	list = { maven = "dependency:tree", gradle = "dependencies" },
	clean = { maven = "clean", gradle = "clean" },
}

function M.root(bufnr)
	local root = vim.fs.root(bufnr or 0, markers)
	if root == nil or root == vim.uv.os_homedir() then
		return nil
	end
	return root
end

local function has(root, name)
	return vim.uv.fs_stat(root .. "/" .. name) ~= nil
end

function M.tool(root)
	if has(root, "mvnw") then
		return "maven", "./mvnw"
	end
	if has(root, "gradlew") then
		return "gradle", "./gradlew"
	end
	if has(root, "pom.xml") then
		return "maven", "mvn"
	end
	return "gradle", "gradle"
end

function M.run(task, prompt)
	local root = M.root()
	if not root then
		vim.notify("No pom.xml, build.gradle or wrapper found above this file", vim.log.levels.WARN)
		return
	end
	local kind, bin = M.tool(root)
	if not bin:match("^%./") and vim.fn.executable(bin) == 0 then
		vim.notify(bin .. " is not on the PATH and the project has no wrapper", vim.log.levels.ERROR)
		return
	end
	local runner = require("apascualco.util.runner")
	runner.with_input(prompt, function(extra)
		local args = tasks[task] and tasks[task][kind] or task
		runner.run(root, runner.join({ bin, args, extra }))
	end)
end

return M

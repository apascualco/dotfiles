local M = {}

function M.main_configs(callback)
	if #vim.lsp.get_clients({ bufnr = 0, name = "jdtls" }) == 0 then
		vim.notify("jdtls is not attached to this buffer", vim.log.levels.WARN)
		return
	end
	require("jdtls.dap").fetch_main_configs({}, function(configs)
		table.sort(configs, function(a, b)
			return a.name < b.name
		end)
		callback(configs)
	end)
end

local function pick(prompt, on_choice)
	M.main_configs(function(configs)
		if #configs == 0 then
			vim.notify("No main class found in the project", vim.log.levels.WARN)
			return
		end
		if #configs == 1 then
			on_choice(configs[1])
			return
		end
		vim.ui.select(configs, {
			prompt = prompt,
			format_item = function(config)
				return config.mainClass .. "  (" .. (config.projectName or "") .. ")"
			end,
		}, function(choice)
			if choice then
				on_choice(choice)
			end
		end)
	end)
end

local function escaped(paths)
	return table.concat(vim.tbl_map(vim.fn.shellescape, paths or {}), ":")
end

function M.run()
	pick("Run main class", function(config)
		local runner = require("apascualco.util.runner")
		local command = runner.join({
			vim.fn.shellescape(config.javaExec or "java"),
			config.vmArgs,
			#(config.modulePaths or {}) > 0 and ("--module-path " .. escaped(config.modulePaths)) or nil,
			#(config.classPaths or {}) > 0 and ("-cp " .. escaped(config.classPaths)) or nil,
			config.mainClass,
		})
		runner.run(config.cwd or vim.fn.getcwd(), command)
	end)
end

function M.debug()
	pick("Debug main class", function(config)
		require("dap").run(config)
	end)
end

return M

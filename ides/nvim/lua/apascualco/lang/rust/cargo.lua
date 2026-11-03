local M = {}

function M.root()
	return vim.fs.root(0, { "Cargo.toml" }) or vim.fn.getcwd()
end

function M.run(args, prompt)
	local runner = require("apascualco.util.runner")
	runner.with_input(prompt, function(extra)
		runner.run(M.root(), runner.join({ "cargo", args, extra }))
	end)
end

return M

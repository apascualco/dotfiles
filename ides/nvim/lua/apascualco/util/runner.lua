local M = {}

function M.run(cwd, command)
	local terminal = require("toggleterm.terminal")
	local id = vim.fn.len(terminal.get_all()) + 1
	terminal.Terminal
		:new({
			cmd = "cd " .. vim.fn.shellescape(cwd) .. " && " .. command,
			direction = "horizontal",
			close_on_exit = false,
			count = id,
			on_exit = function(_, _, code)
				local level = code == 0 and vim.log.levels.INFO or vim.log.levels.WARN
				vim.notify(command .. " [" .. id .. "] exited with code " .. code, level)
			end,
		})
		:toggle()
end

function M.with_input(prompt, on_input)
	if not prompt then
		on_input("")
		return
	end
	vim.ui.input({ prompt = prompt }, function(input)
		if input ~= nil then
			on_input(input)
		end
	end)
end

function M.join(parts)
	return table.concat(
		vim.tbl_filter(function(part)
			return part ~= nil and part ~= ""
		end, parts),
		" "
	)
end

return M

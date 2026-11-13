local buf = vim.api.nvim_get_current_buf()
if not (vim.treesitter.highlighter and vim.treesitter.highlighter.active[buf]) then
	pcall(vim.treesitter.start, buf, "json")
end
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true

local jsonl = require("apascualco.util.jsonl")
vim.keymap.set("n", "<leader>jq", jsonl.preview_record, { buffer = buf, desc = "Pretty-print record" })
vim.api.nvim_buf_create_user_command(
	buf,
	"JsonlPretty",
	jsonl.pretty_whole_file,
	{ desc = "Pretty-print whole file (read-only scratch)" }
)

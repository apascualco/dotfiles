return {
	{
		"coder/claudecode.nvim",
		cmd = {
			"ClaudeCode",
			"ClaudeCodeFocus",
			"ClaudeCodeSelectModel",
			"ClaudeCodeAdd",
			"ClaudeCodeSend",
			"ClaudeCodeTreeAdd",
			"ClaudeCodeDiffAccept",
			"ClaudeCodeDiffDeny",
			"ClaudeCodeStatus",
		},
		opts = function()
			local local_bin = vim.fn.expand("~/.claude/local/claude")
			return {
				log_level = "info",
				terminal_cmd = vim.fn.filereadable(local_bin) == 1 and local_bin or "claude",
				cwd = vim.fn.getcwd(),
				git_repo_cwd = true,
				terminal = { split_side = "right", provider = "auto", auto_close = true, snacks_win_opts = {} },
				diff_opts = {
					auto_close_on_accept = true,
					vertical_split = true,
					open_in_current_tab = true,
					keep_terminal_focus = false,
				},
				focus_after_send = false,
				track_selection = true,
				visual_demotion_delay_ms = 50,
			}
		end,
	},

	{
		"johnseth97/codex.nvim",
		cmd = { "Codex", "CodexToggle" },
		keys = {
			{
				"<leader>cx",
				function()
					require("codex").toggle()
				end,
				desc = "Toggle Codex",
			},
		},
		opts = { keymaps = { toggle = nil }, border = "rounded", width = 0.4, autoinstall = false, panel = true },
		config = function(_, opts)
			require("codex").setup(opts)
			vim.api.nvim_create_autocmd({ "BufWinEnter", "WinNew" }, {
				group = vim.api.nvim_create_augroup("CodexPanelRight", { clear = true }),
				callback = function()
					vim.schedule(function()
						for _, win in ipairs(vim.api.nvim_list_wins()) do
							if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "codex" then
								vim.api.nvim_win_call(win, function()
									vim.cmd("wincmd L")
								end)
								return
							end
						end
					end)
				end,
			})
		end,
	},
}

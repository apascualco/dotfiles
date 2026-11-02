local fim_prefix, fim_suffix, fim_middle = "<|fim_prefix|>", "<|fim_suffix|>", "<|fim_middle|>"

require("minuet").setup({
	provider = "openai_fim_compatible",
	n_completions = 1,
	context_window = 4000,
	context_ratio = 0.75,
	throttle = 800,
	debounce = 300,
	request_timeout = 5,
	notify = "warn",
	virtualtext = {
		auto_trigger_ft = { "*" },
		auto_trigger_ignore_ft = {
			"TelescopePrompt", "NvimTree", "snacks_input", "snacks_picker_input", "DressingInput",
			"toggleterm", "dap-repl", "dapui_watches", "grug-far", "dbui", "dbout", "lazy", "mason", "oil", "minifiles",
		},
		keymap = {
			accept = "<C-l>",
			accept_line = "<C-Right>",
			dismiss = "<C-]>",
			next = "<M-]>",
			prev = "<M-[>",
		},
		show_on_completion_menu = true,
	},
	provider_options = {
		openai_fim_compatible = {
			api_key = function() return "ollama" end,
			name = "Ollama",
			end_point = "http://localhost:11434/api/generate",
			model = "qwen3-coder",
			stream = true,
			template = {
				prompt = function(before, after, _)
					local language = require("minuet.utils").add_language_comment()
					return fim_prefix .. language .. "\n" .. before .. fim_suffix .. after .. fim_middle
				end,
				suffix = false,
			},
			optional = {
				raw = true,
				keep_alive = "1h",
				options = {
					num_predict = 64,
					temperature = 0.2,
					top_p = 0.9,
					stop = { "<|endoftext|>", "<|fim_pad|>", "<|repo_name|>", "<|file_sep|>", "<|im_end|>", "\n\n" },
				},
			},
			get_text_fn = {
				stream = function(json) return json.response end,
				no_stream = function(json) return json.response end,
			},
		},
	},
})

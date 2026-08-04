-- JSONL (.jsonl): un objeto JSON por línea.
--
-- Nota de diseño: NO reutilizamos el trato completo de `json` (jsonls + prettier
-- en format_on_save) porque romperían el archivo — prettier/jq sobre el buffer
-- entero juntaría todos los registros en un único objeto multilínea (deja de ser
-- JSONL), y jsonls marcaría error en todo lo que no sea la primera línea. En su
-- lugar damos lo que sí tiene sentido en JSONL:
--   1) mismo resaltado que JSON (reutiliza el parser treesitter `json`)
--   2) lectura cómoda de logs largos minificados (wrap) sin tocar el archivo
--   3) <leader>jq  → pretty-print del registro bajo el cursor en un flotante
--   4) :JsonlPretty → todo el archivo formateado en un buffer scratch (solo lectura)

-- Para cualquier búsqueda de treesitter, el filetype `jsonl` usa el parser `json`.
pcall(vim.treesitter.language.register, "json", "jsonl")

-- Abre `lines` en un buffer scratch flotante, resaltado como JSON, solo lectura.
local function open_float(lines, title)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].filetype = "json"
	vim.bo[buf].modifiable = false
	vim.bo[buf].bufhidden = "wipe"

	local width = math.min(100, vim.o.columns - 4)
	local height = math.min(#lines, vim.o.lines - 6)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = math.max(height, 1),
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
		title = title and (" " .. title .. " ") or nil,
		title_pos = "center",
	})
	pcall(vim.treesitter.start, buf, "json")
	for _, key in ipairs({ "q", "<Esc>" }) do
		vim.keymap.set("n", key, function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end, { buffer = buf, nowait = true, silent = true })
	end
	return win
end

-- Corre `jq .` sobre `input` (string). Devuelve las líneas o nil + mensaje.
local function jq_pretty(input)
	if vim.fn.executable("jq") == 0 then
		return nil, "jq no está instalado"
	end
	local out = vim.fn.systemlist({ "jq", "." }, input)
	if vim.v.shell_error ~= 0 then
		return nil, "JSON no válido"
	end
	return out
end

-- Pretty-print del registro (línea actual) en un flotante.
local function preview_record()
	local line = vim.api.nvim_get_current_line()
	if line:match("^%s*$") then
		return
	end
	local lnum = vim.api.nvim_win_get_cursor(0)[1]
	local out, err = jq_pretty(line)
	if not out then
		vim.notify(err .. " (línea " .. lnum .. ")", vim.log.levels.WARN)
		return
	end
	open_float(out, "record L" .. lnum)
end

-- Todo el archivo formateado (cada registro expandido) en un buffer scratch.
-- `jq .` acepta un stream de valores JSON y pretty-imprime cada uno en orden.
local function pretty_whole_file()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local out, err = jq_pretty(table.concat(lines, "\n"))
	if not out then
		vim.notify(err, vim.log.levels.ERROR)
		return
	end
	local src = vim.api.nvim_buf_get_name(0)
	vim.cmd("botright vsplit")
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(0, buf)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
	vim.bo[buf].filetype = "json"
	vim.bo[buf].modifiable = false
	vim.bo[buf].bufhidden = "wipe"
	if src ~= "" then
		pcall(vim.api.nvim_buf_set_name, buf, src .. " [pretty]")
	end
	pcall(vim.treesitter.start, buf, "json")
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "jsonl",
	callback = function(args)
		-- Resaltado idéntico a JSON.
		if not (vim.treesitter.highlighter and vim.treesitter.highlighter.active[args.buf]) then
			pcall(vim.treesitter.start, args.buf, "json")
		end
		-- Lectura cómoda de líneas largas minificadas.
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true

		vim.keymap.set("n", "<leader>jq", preview_record,
			{ buffer = args.buf, desc = "JSONL — pretty registro bajo el cursor" })
		vim.api.nvim_buf_create_user_command(args.buf, "JsonlPretty", pretty_whole_file,
			{ desc = "JSONL — todo el archivo formateado (scratch, solo lectura)" })
	end,
})

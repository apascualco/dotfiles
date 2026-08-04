local lsp_setup = require("apascualco.plugins.lsp.setup")

-- Soporte gRPC / Protocol Buffers para proyectos "api contract" (módulos buf).
--
-- El LSP vive DENTRO del propio CLI `buf` (paquete Mason `buf`, expuesto en
-- ~/.local/share/nvim/mason/bin/buf). Da diagnostics (lint + breaking + build),
-- hover, go-to-def, references y completado, resolviendo buf.yaml / buf.gen.yaml
-- / buf.work.yaml del repo y sus dependencias (incl. BSR).
--
-- OJO con el comando: es `buf lsp serve`. El antiguo `buf beta lsp` está
-- deprecado (avisa por stderr) — no lo uses.

-- Trata los ficheros de configuración de buf como filetype `buf-config` para que
-- buf_ls también los valide (typos en reglas de lint/breaking, deps mal escritas…).
-- Muy útil en repos api-contract, que son básicamente estos YAML + los .proto.
vim.filetype.add({
	filename = {
		["buf.yaml"] = "buf-config",
		["buf.gen.yaml"] = "buf-config",
		["buf.work.yaml"] = "buf-config",
		["buf.lock"] = "buf-config",
	},
})
-- …y que treesitter los resalte como YAML (parser ya instalado en treesitter.lua).
-- El formateo de estos ficheros sigue siendo prettier (conform: ver lazy.lua).
pcall(vim.treesitter.language.register, "yaml", "buf-config")

vim.lsp.config("buf_ls", {
	on_attach    = lsp_setup.on_attach,
	cmd          = { "buf", "lsp", "serve", "--log-format=text" },
	filetypes    = { "proto", "buf-config" },
	-- buf.work.yaml cubre workspaces multi-módulo (típico en un api-contract).
	root_markers = { "buf.yaml", "buf.work.yaml", "buf.gen.yaml", ".git" },
	capabilities = lsp_setup.capabilities,
})

vim.lsp.enable("buf_ls")

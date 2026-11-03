return {
	settings = {
		yaml = {
			schemaStore = { enable = false, url = "" },
			schemas = require("schemastore").yaml.schemas(),
			validate = true,
			format = { enable = false },
			keyOrdering = false,
		},
		redhat = { telemetry = { enabled = false } },
	},
}

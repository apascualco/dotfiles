require("dap").adapters.go_remote = function(callback, config)
	callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 2345 })
end

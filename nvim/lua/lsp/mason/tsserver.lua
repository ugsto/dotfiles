local M = {}

-- Disable tsserver formatting
M.on_attach = function(client, bufnr)
	client.server_capabilities.documentFormattingProvider = false
end

return M

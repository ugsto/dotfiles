return function()
	local on_attach = function(client, _)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end

	require("lspconfig").lua_ls.setup({
		on_attach = on_attach,
		settings = {
			implicitProjectConfiguration = {
				checkJs = true,
			},
		},
	})
end

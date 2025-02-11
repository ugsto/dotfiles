return function()
	require("lspconfig").lua_ls.setup({
		settings = {
			Lua = {
				format = {
					enable = false,
				},
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	})
end

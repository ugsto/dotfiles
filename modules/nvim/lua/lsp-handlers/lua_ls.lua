return function()
	require("lspconfig").lua_ls.setup({
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				format = {
					enable = false,
				},
			},
		},
	})
end

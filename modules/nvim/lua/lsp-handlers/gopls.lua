return function()
	local cfg = require("go.lsp").config()

	cfg.settings = {
		gopls = {
			analyses = {
				shadow = false,
			},
		},
	}

	require("lspconfig").gopls.setup(cfg)
end

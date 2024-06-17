return function()
	local cfg = require("go.lsp").config()

	require("lspconfig").gopls.setup(cfg)
end

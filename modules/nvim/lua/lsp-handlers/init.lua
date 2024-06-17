local lspconfig = require("lspconfig")

local M = {
	function(server_name)
		lspconfig[server_name].setup({})
	end,
}

M["lua_ls"] = require("lsp-handlers.lua_ls")
M["gopls"] = require("lsp-handlers.gopls")

return M

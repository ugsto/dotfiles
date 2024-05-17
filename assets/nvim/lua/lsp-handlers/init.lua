local lspconfig = require("lspconfig")

local M = {
	function(server_name)
		lspconfig[server_name].setup({})
	end,
}

M["rust_analyzer"] = require("lsp-handlers.rust_analyzer").handler
M["lua_ls"] = require("lsp-handlers.lua_ls").handler

return M

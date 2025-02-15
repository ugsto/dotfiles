local lspconfig = require("lspconfig")

return {
	function(server_name)
		lspconfig[server_name].setup({})
	end,

	lua_ls = require("ugvim.lsp-handlers.lua_ls"),
	ts_ls = require("ugvim.lsp-handlers.ts_ls"),
	svelte = require("ugvim.lsp-handlers.svelte"),
	clangd = require("ugvim.lsp-handlers.clangd"),
}

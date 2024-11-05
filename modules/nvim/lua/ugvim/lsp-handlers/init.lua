local lspconfig = require("lspconfig")

local M = {
  function(server_name)
    lspconfig[server_name].setup({})
  end,
}

M["lua_ls"] = require("ugvim.lsp-handlers.lua_ls")
-- M["gopls"] = require("lsp-handlers.gopls")
M["ts_ls"] = require("ugvim.lsp-handlers.ts_ls")
M["svelte"] = require("ugvim.lsp-handlers.svelte")

return M

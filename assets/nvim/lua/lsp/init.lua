local M = {}

local border_setup = require("lsp.border").setup
border_setup()

local lua_ls_handler = require("lsp.handlers.lua_ls").handler

M.handlers = {
  function (server_name)
    require("lspconfig")[server_name].setup {}
  end
}
M.handlers["lua_ls"] = lua_ls_handler

return M

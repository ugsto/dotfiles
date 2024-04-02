local M = {}

M.handler = function ()
  require("lspconfig").lua_ls.setup {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" }
        }
      }
    }
  }
end

return M

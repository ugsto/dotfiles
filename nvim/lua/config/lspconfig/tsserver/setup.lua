local M = require("config.lspconfig").config

local original_on_attach = M.on_attach
M.on_attach = function(client, bufnr)
    original_on_attach(client, bufnr)

    if client.resolved_capabilities == nil then
        client.resolved_capabilities = {}
    end

    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
end

return M

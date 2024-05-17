vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("LspFormatting", {}),
  pattern = "*",
  callback = function()
    local clients = vim.lsp.get_active_clients()
    for _, client in pairs(clients) do
      if client.server_capabilities.documentFormattingProvider then
        vim.lsp.buf.format()
        break
      end
    end
  end,
})

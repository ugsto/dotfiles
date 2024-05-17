vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local mapping_setup = require("mappings.lsp")
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = ev.buf }
    mapping_setup.setup(opts)
  end,
})

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

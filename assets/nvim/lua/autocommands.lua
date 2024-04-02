local mapping = require("utils")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = ev.buf }
    mapping.map("n", "gD", vim.lsp.buf.declaration, opts)
    mapping.map("n", "gd", vim.lsp.buf.definition, opts)
    mapping.map("n", "K", vim.lsp.buf.hover, opts)
    mapping.map("n", "gi", vim.lsp.buf.implementation, opts)
    mapping.map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    mapping.map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    mapping.map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    mapping.map("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    mapping.map("n", "<space>D", vim.lsp.buf.type_definition, opts)
    mapping.map("n", "<space>rn", vim.lsp.buf.rename, opts)
    mapping.map({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
    mapping.map("n", "gr", vim.lsp.buf.references, opts)
    mapping.map("n", "<space>f", function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("LspFormatting", {}),
  pattern = "*",
  callback = function()
    vim.lsp.buf.format()
  end,
})

local autoformat_group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })


local function format_buffer()
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.server_capabilities.documentFormattingProvider then
      vim.lsp.buf.format()
      break
    end
  end
end

local function enable_autoformat()
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = autoformat_group,
    pattern = "*",
    callback = format_buffer,
  })

  vim.notify("Autoformatting enabled")
end

local function disable_autoformat()
  vim.api.nvim_clear_autocmds({ group = autoformat_group })

  vim.notify("Autoformatting disabled")
end

vim.api.nvim_create_user_command("AutoformatOn", enable_autoformat, {})
vim.api.nvim_create_user_command("AutoformatOff", disable_autoformat, {})

enable_autoformat()

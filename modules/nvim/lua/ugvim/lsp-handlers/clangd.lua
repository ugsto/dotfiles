return function()
  require("lspconfig").clangd.setup({
    filetypes = { "c", "cpp", "objc", "objcpp" }, -- Exclude .proto
  })
end

return function()
  require("lspconfig").svelte.setup({
    settings = {
      svelte = {
        plugin = {
          svelte = {
            format = {
              enable = false
            }
          }
        }
      }
    }
  })
end

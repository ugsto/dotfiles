local M = {}

M.config = {
  formatting = {
    disabled = {
      "tsserver"
    }
  },
}

M.setup_handlers = {
  rust_analyzer = function(_, opts)
    opts.settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy"
        },
      },
    }
    require("rust-tools").setup({ server = opts })
  end
}

return M

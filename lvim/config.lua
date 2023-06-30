table.insert(lvim.plugins, {
  "zbirenbaum/copilot-cmp",
  event = "InsertEnter",
  dependencies = { "zbirenbaum/copilot.lua" },
  config = function()
    vim.defer_fn(function()
      require("copilot").setup({
        filetypes = {
          ["*"] = true,
        }
      })
      require("copilot_cmp").setup()
    end, 100)
  end,
})

table.insert(lvim.plugins, {
  "folke/todo-comments.nvim",
  event = "BufRead",
  config = function()
    require("todo-comments").setup()
  end,
})

table.insert(lvim.plugins, {
  "mipmip/vim-scimark",
})

table.insert(lvim.plugins, {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000
})

table.insert(lvim.plugins, {
  "ray-x/lsp_signature.nvim",
  event = "BufRead",
  config = function() require "lsp_signature".on_attach() end,
})

lvim.keys.normal_mode["<C-S>"] = ":OpenInScim<CR>"
lvim.format_on_save.enabled = true

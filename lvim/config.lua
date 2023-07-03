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
  "iamcco/markdown-preview.nvim",
  build = "cd app && npm install",
  ft = "markdown",
  config = function()
    vim.g.mkdp_auto_start = 1
  end,
})

table.insert(lvim.plugins, {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  init = function() vim.g.barbar_auto_setup = false end,
  opts = {
    animation = true,
    insert_at_start = true,
  },
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

lvim.keys.normal_mode["<C-S>"] = "<Cmd>OpenInScim<CR>"

lvim.keys.normal_mode["<A-,>"] = "<Cmd>BufferPrevious<CR>"
lvim.keys.normal_mode["<A-.>"] = "<Cmd>BufferNext<CR>"

lvim.keys.normal_mode["<A-<>"] = "<Cmd>BufferMovePrevious<CR>"
lvim.keys.normal_mode["<A->>"] = "<Cmd>BufferMoveNext<CR>"

lvim.format_on_save.enabled = true

lvim.lsp.automatic_configuration.skipped_filetypes = vim.tbl_filter(function(filetype)
  return filetype ~= "markdown"
end, lvim.lsp.automatic_configuration.skipped_filetypes)

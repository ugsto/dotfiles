return {
  colorscheme = "catppuccin-macchiato",

  lsp = {
    formatting = {
      format_on_save = true,
      disabled = {
        "tsserver"
      }
    }
  },


  plugins = {
    {
      "catppuccin/nvim",
      name = "catppuccin",
      config = function()
        require("catppuccin").setup {}
      end
    },
    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
        require("copilot").setup {
          suggestion = { enabled = false },
          panel = { enabled = false },
          filetypes = {
            ["*"] = true,
            make = true,
          }
        }
      end
    },
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        {
          "zbirenbaum/copilot-cmp",
          config = function()
            require("copilot_cmp").setup()
          end,
        }
      },
      opts = {
        sources = {
          { name = "nvim_lsp", group_index = 2 },
          { name = "copilot",  group_index = 2 },
          { name = "luasnip",  group_index = 2 },
          { name = "buffer",   group_index = 2 },
          { name = "nvim_lua", group_index = 2 },
          { name = "path",     group_index = 2 },
        },
      },
    },
  }
}

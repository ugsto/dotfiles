return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "BufEnter",
  config = function()
    require("fzf-lua").setup({ "telescope" })
  end,
  keys = {
    { "<leader>ff", "<CMD>FzfLua files<CR>",        desc = "fzf - files" },
    { "<leader>fg", "<CMD>FzfLua grep_visual<CR>",  desc = "fzf - grep" },
    { "<leader>ft", "<CMD>FzfLua tabs<CR>",         desc = "fzf - tabs" },
    { "<leader>fc", "<CMD>FzfLua colorschemes<CR>", desc = "fzf - colorschemes" },
  }
}

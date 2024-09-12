return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    require('mini.basics').setup()
    require('mini.comment').setup()
    require('mini.completion').setup()
    require('mini.icons').setup()
    require('mini.pairs').setup()
    require('mini.statusline').setup()
    require('mini.surround').setup()
    require('mini.tabline').setup()
    require('mini.files').setup()
  end,
}

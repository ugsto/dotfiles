local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('n', '<leader>q', ':q<CR>')
map('n', '<leader>w', ':w<CR>')

map('n', '<leader>e', ':e .<CR>')

map('n', '<C-w>h', ':bprevious<CR>')
map('n', '<C-w>l', ':bnext<CR>')

map('n', '<A-w>', ':bdelete<CR>')

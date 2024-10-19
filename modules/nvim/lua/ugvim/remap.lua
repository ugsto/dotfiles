local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", "<leader>q", "<CMD>q<CR>")
map("n", "<leader>w", "<CMD>w<CR>")

map("n", "<C-w>h", "<CMD>bprevious<CR>")
map("n", "<C-w>l", "<CMD>bnext<CR>")

map("n", "<A-w>", "<CMD>bdelete<CR>")

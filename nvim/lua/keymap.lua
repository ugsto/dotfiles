local M = {}

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
local buf_keymap = vim.api.nvim_buf_set_keymap
keymap("", "<space>", "<Nop>", opts)
vim.g.mapleader = " "

keymap("n", "<leader>w", "<cmd>w<cr>", opts)
keymap("n", "<leader>q", "<cmd>q<cr>", opts)
keymap("n", "th", "<cmd>tabprev<cr>", opts)
keymap("n", "tl", "<cmd>tabnext<cr>", opts)
keymap("n", "mc", "<cmd>set clipboard=unnamedplus<cr>", opts)
keymap("n", "md", "<cmd>set clipboard=<cr>", opts)

-- NVIM-TREE

keymap("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", opts)

-- LSP

keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
keymap('n', '<leader>d', '<cmd>lua vim.diagnostic.setloclist()<cr>', opts)

M.lsp_handler_on_attach = function(bufnr)
  buf_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  buf_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  buf_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  buf_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  buf_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  buf_keymap(bufnr, 'n', 'gf', '<cmd>lua vim.lsp.buf.format()<cr>', opts)
end

local status_ok, cmp = pcall(require, 'cmp')
if status_ok then
  M.lsp_cmp = {
    ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<cr>'] = cmp.mapping.confirm({ select = true })
  }
else
  M.cmp = {}
end

-- TREESITTER

keymap('n', '<leader>f', '<cmd>Telescope find_files<cr>', opts)
keymap('n', '<leader>g', '<cmd>Telescope live_grep<cr>', opts)

-- FLOATERM

keymap('n', '<C-f>', '<cmd>FloatermNew --height=0.8 --width=0.6 --wintype=float --name=terminal<cr>', opts)

return M

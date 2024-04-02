local mapping = require("utils")
vim.g.mapleader = " "

mapping.map("n", "<leader>e", ":Neotree<CR>")
mapping.map("n", "<leader><leader>e", ":Neotree buffers<CR>")
mapping.map("n", "<leader>q", ":q<CR>")
mapping.map("n", "<leader>w", ":w<CR>")

mapping.map("n", "[d", vim.diagnostic.goto_prev)
mapping.map("n", "]d", vim.diagnostic.goto_next)

mapping.map("n", "<leader>ff", ":Telescope find_files<CR>")
mapping.map("n", "<leader>fg", ":Telescope live_grep<CR>")
mapping.map("n", "<leader>fb", ":Telescope buffers<CR>")
mapping.map("n", "<leader>fh", ":Telescope help_tags<CR>")

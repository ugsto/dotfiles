local mapping = require("utils")
vim.g.mapleader = " "

mapping.map("n", "<leader>q", "<CMD>q<CR>")
mapping.map("n", "<leader>w", "<CMD>w<CR>")

mapping.map("n", "<leader>ff", "<CMD>Telescope find_files<CR>")
mapping.map("n", "<leader>fg", "<CMD>Telescope live_grep<CR>")
mapping.map("n", "<leader>fb", "<CMD>Telescope buffers<CR>")
mapping.map("n", "<leader>fh", "<CMD>Telescope help_tags<CR>")

mapping.map("n", "<A-,>", "<CMD>BufferPrevious<CR>")
mapping.map("n", "<A-.>", "<CMD>BufferNext<CR>")

mapping.map("n", "<A-<>", "<CMD>BufferMovePrevious<CR>")
mapping.map("n", "<A->>", "<CMD>BufferMoveNext<CR>")

mapping.map("n", "<A-1>", "<CMD>BufferGoto 1<CR>")
mapping.map("n", "<A-2>", "<CMD>BufferGoto 2<CR>")
mapping.map("n", "<A-3>", "<CMD>BufferGoto 3<CR>")
mapping.map("n", "<A-4>", "<CMD>BufferGoto 4<CR>")
mapping.map("n", "<A-5>", "<CMD>BufferGoto 5<CR>")
mapping.map("n", "<A-6>", "<CMD>BufferGoto 6<CR>")
mapping.map("n", "<A-7>", "<CMD>BufferGoto 7<CR>")
mapping.map("n", "<A-8>", "<CMD>BufferGoto 8<CR>")
mapping.map("n", "<A-9>", "<CMD>BufferGoto 9<CR>")
mapping.map("n", "<A-0>", "<CMD>BufferLast<CR>")

mapping.map("n", "<A-p>", "<CMD>BufferPin<CR>")

mapping.map("n", "<A-c>", "<CMD>BufferClose<CR>")

mapping.map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>')
mapping.map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>')
mapping.map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>')
mapping.map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>')
mapping.map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>')

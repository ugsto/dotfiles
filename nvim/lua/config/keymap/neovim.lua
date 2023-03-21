local function config_keymap()
    local map = require("utils.map")

    vim.g.mapleader = " "
    map("n", "<leader>q", "<cmd>q<CR>", { silent = true })
    map("n", "<leader>w", "<cmd>w<CR>", { silent = true })

    -- Telescope
    map("n", "<leader>E", "<cmd>Telescope find_files<CR>", { silent = true })

    -- nvim-tree
    map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { silent = true })

    -- ChatGPT
    map("n", "<leader>c", "<cmd>ChatGPT<CR>", { silent = true })

    -- Tab
    map("n", "<C-w>t", "<cmd>tabnew<CR>", { silent = true })
    map("n", "<C-w>d", "<cmd>tabclose<CR>", { silent = true })
    map("n", "<C-w>h", "<cmd>tabprevious<CR>", { silent = true })
    map("n", "<C-w>l", "<cmd>tabnext<CR>", { silent = true })
end

return config_keymap

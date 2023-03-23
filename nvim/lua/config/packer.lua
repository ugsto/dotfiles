local function get_packer(use)
    return function()
        -- Packer bootstrap
        use({
            "wbthomason/packer.nvim",
        })

        -- LSP
        use({
            "neovim/nvim-lspconfig",
        })
        use({
            "williamboman/mason.nvim",
            requires = {
                "neovim/nvim-lspconfig",
            },
        })
        use({
            "williamboman/mason-lspconfig.nvim",
            requires = {
                "williamboman/mason.nvim",
                "neovim/nvim-lspconfig",
            },
        })
        use({
            "jose-elias-alvarez/null-ls.nvim",
            requires = {
                "nvim-lua/plenary.nvim",
                "neovim/nvim-lspconfig",
            },
        })
        use({
            "hrsh7th/nvim-cmp",
            requires = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-cmdline",
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",
                "neovim/nvim-lspconfig",
            },
        })
        use({
            "ray-x/lsp_signature.nvim",
            requires = {
                "neovim/nvim-lspconfig",
            },
        })
        use({
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
        })

        -- Colorscheme
        use({
            "navarasu/onedark.nvim",
        })

        -- File explorer
        use({
            "nvim-tree/nvim-tree.lua",
            requires = {
                "nvim-tree/nvim-web-devicons",
            },
        })
        use({
            "nvim-telescope/telescope.nvim",
            requires = {
                "nvim-lua/plenary.nvim",
                "nvim-lua/popup.nvim",
            },
        })

        -- Type helpers
        use({
            "windwp/nvim-autopairs",
        })

        -- Copilot
        use({
            "github/copilot.vim",
        })

        -- ChatGpt
        use({
            "jackMort/ChatGPT.nvim",
            requires = {
                "MunifTanjim/nui.nvim",
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope.nvim",
            },
        })

        -- Statusline
        use({
            "nvim-lualine/lualine.nvim",
            requires = { "kyazdani42/nvim-web-devicons", opt = true },
        })

        -- Markdown
        use({
            "iamcco/markdown-preview.nvim",
            run = "cd app && yarn install",
            ft = "markdown",
        })
    end
end

return get_packer

local function preflight()
	local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

	if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
		vim.cmd("!git clone --depth 1 https://github.com/wbthomason/packer.nvim " .. install_path)

		vim.cmd("qall")
	end
end

local function loader(use)
	use({ "wbthomason/packer.nvim" })

	use({
		"williamboman/mason.nvim",
		requires = { "neovim/nvim-lspconfig" },
		run = ":MasonUpdate",
	})
	use({
		"williamboman/mason-lspconfig.nvim",
		requires = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
	})
	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { "neovim/nvim-lspconfig", "nvim-lua/plenary.nvim" },
	})
	use({
		"hrsh7th/nvim-cmp",
		requires = { "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-vsnip", "hrsh7th/vim-vsnip" },
	})
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	use({ "github/copilot.vim" })
	use({
		"jackMort/ChatGPT.nvim",
		requires = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	})

	use({
		"nvim-tree/nvim-tree.lua",
		requires = { "nvim-tree/nvim-web-devicons" },
	})

	use({
		"catppuccin/nvim",
	})

	use({
		"nvim-lualine/lualine.nvim",
		requires = {
			"nvim-tree/nvim-web-devicons",
			opt = true,
		},
		config = function()
			require("lualine").setup()
		end,
	})

	use({ "davidgranstrom/nvim-markdown-preview" })

	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	})
end

local function setup()
	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		callback = function()
			require("packer").compile()
		end,
	})

	local packer = require("packer")

	packer.startup(loader)
end

local function main()
	preflight()
	setup()
end

main()

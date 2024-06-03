return {
	{
		"olimorris/onedarkpro.nvim",
		priority = 1000,
	},
	{
		"rafamadriz/neon",
		priority = 1000,
	},
	{
		"folke/tokyonight.nvim",
		priority = 1000,
	},
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
	},
	{
		"EdenEast/nightfox.nvim",
		priority = 1000,
	},
	{
		"catppuccin/nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin-macchiato")
		end,
	},
}

local logger = require("loaders.logger")

local function setup()
	local ts = require("nvim-treesitter.configs")
	ts.setup({
		ensure_installed = {
			"bash",
			"css",
			"dockerfile",
			"fish",
			"html",
			"javascript",
			"json",
			"lua",
			"python",
			"regex",
			"rust",
			"toml",
			"tsx",
			"typescript",
			"yaml",
		},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = {
			enable = true,
		},
		autotag = {
			enable = true,
		},
		autopairs = {
			enable = true,
		},
		context_commentstring = {
			enable = true,
		},
	})
end

local function main()
	setup()
end

main()

local function setup()
	vim.o.termguicolors = true
	vim.o.background = "dark"

	vim.cmd("colorscheme catppuccin-mocha")
end

local function main()
	setup()
end

main()

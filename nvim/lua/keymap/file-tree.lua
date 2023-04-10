local function setup()
	local map = require("utils.map")

	local opts = {}

	map("n", "<leader>e", function()
		vim.cmd("NvimTreeToggle")
	end, opts)
end

local function main()
	setup()
end

main()

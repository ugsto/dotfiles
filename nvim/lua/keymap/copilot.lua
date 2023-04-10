local function setup()
	local map = require("utils.map")

	map("n", "<C-E>", function()
		vim.cmd("Copilot panel")
	end)
end

local function main()
	setup()
end

main()

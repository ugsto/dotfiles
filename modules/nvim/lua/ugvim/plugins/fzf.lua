return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "BufEnter",
	config = function()
		local fzf_lua = require("fzf-lua")
		fzf_lua.setup({ "telescope" })
		vim.ui.select = function(items, opts, on_choice)
			local choices = {}
			for i, item in pairs(items) do
				choices[i] = opts.format_item and opts.format_item(item) or tostring(item)
			end

			fzf_lua.fzf_exec(choices, {
				prompt = opts.prompt or "",
				actions = {
					["default"] = function(selected)
						local index = nil
						for i, choice in pairs(choices) do
							if choice == selected[1] then
								index = i
								break
							end
						end
						if index then
							on_choice(items[index], index)
						else
							on_choice(nil, nil)
						end
					end,
				},
			})
		end
	end,
	keys = {
		{ "<leader>ff", "<CMD>FzfLua files<CR>", desc = "fzf - files" },
		{ "<leader>fg", "<CMD>FzfLua grep_visual<CR>", desc = "fzf - grep" },
		{ "<leader>ft", "<CMD>FzfLua tabs<CR>", desc = "fzf - tabs" },
		{ "<leader>fc", "<CMD>FzfLua colorschemes<CR>", desc = "fzf - colorschemes" },
	},
}

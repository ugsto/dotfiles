local logger = require("loaders.logger")

local function load_copilot()
	vim.g.copilot_filetypes = {
		["*"] = false,
		["javascript"] = true,
		["typescript"] = true,
		["typescriptreact"] = true,
		["lua"] = true,
		["c"] = true,
		["c#"] = true,
		["c++"] = true,
		["go"] = true,
		["python"] = true,
		["ruby"] = true,
		["rust"] = true,
		["markdown"] = true,
		["yaml"] = true,
		["sh"] = true,
		["css"] = true,
		["html"] = true,
		["json"] = true,
		["jsonc"] = true,
		["make"] = true,
		["jinja2"] = true,
		["toml"] = true,
		["scss"] = true,
		["dockerfile"] = true,
		["dockerignore"] = true,
		["gitignore"] = true,
		["nginx"] = true,
		["tex"] = true,
		["dosini"] = true,
		["hosts"] = true,
		["conf"] = true,
		["text"] = true,
		["zsh"] = true,
		["nearley"] = true,
		["arduino"] = true,
		["java"] = true,
	}
end

local function load_chatgpt()
	local has_chatgpt_loaded, chatgpt = pcall(require, "chatgpt")

	if not has_chatgpt_loaded then
		logger.warning("ChatGPT.nvim is not installed")
		return
	end

	chatgpt.setup({
		keymaps = {
			close = { "<C-c>" },
			submit = "<C-s>",
			yank_last = "<C-y>",
			yank_last_code = "<C-k>",
			scroll_up = "<C-u>",
			scroll_down = "<C-d>",
			toggle_settings = "<C-o>",
			new_session = "<C-n>",
			cycle_windows = "<Tab>",
			select_session = "<Space>",
			rename_session = "r",
			delete_session = "d",
		},
	})
end

local function setup()
	load_copilot()
	load_chatgpt()
end

local function main()
	setup()
end

main()

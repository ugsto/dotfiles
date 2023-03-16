local try_require = require("utils.try-require") or os.exit(1)

local function config_keymap()
    local map = try_require("utils.map") or os.exit(1)

    map("n", "<leader>ca", "<cmd>CopilotAnalyze<CR>", { silent = true })
end

return config_keymap

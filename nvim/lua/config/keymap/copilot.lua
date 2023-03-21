local function config_keymap()
    local map = require("utils.map")

    map("n", "<leader>ca", "<cmd>CopilotAnalyze<CR>", { silent = true })
end

return config_keymap

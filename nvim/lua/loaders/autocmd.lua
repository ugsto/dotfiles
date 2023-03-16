local try_require = require("utils.try-require")

local function setup()
    local config = try_require("config.autocmd") or os.exit(1)

    for _, config_it in ipairs(config) do
        local event = config_it[1]
        local pattern = config_it[2]
        local command = config_it[3]

        vim.api.nvim_create_autocmd(event, { pattern = pattern, command = command })
    end
end

local function main()
    setup()
end

main()

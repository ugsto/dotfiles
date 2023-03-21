local function setup()
    local lualine = require("lualine")
    local config = require("config.lualine")

    lualine.setup(config)
end

local function main()
    setup()
end

main()

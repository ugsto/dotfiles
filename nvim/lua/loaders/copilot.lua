local function setup()
    local keymap_fn = require("config.keymap.copilot")
    local config_fn = require("config.copilot")

    keymap_fn()
    config_fn()
end

local function main()
    setup()
end

main()


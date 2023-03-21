local function setup()
    local keymap_fn = require("config.keymap.neovim")
    local config_fn = require("config.neovim")

    keymap_fn()
    config_fn()
end

local function main()
    setup()
end

main()


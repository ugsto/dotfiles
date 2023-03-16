local try_require = require("utils.try-require") or os.exit(1)

local function setup()
    local keymap_fn = try_require("config.keymap.neovim") or os.exit(1)
    local config_fn = try_require("config.neovim") or os.exit(1)

    keymap_fn()
    config_fn()
end

local function main()
    setup()
end

main()
local try_require = require("utils.try-require")

local function setup()
    local nvim_autopairs = try_require("nvim-autopairs") or os.exit(1)

    nvim_autopairs.setup()
end

local function main()
    setup()
end

main()

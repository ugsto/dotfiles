local try_require = require("utils.try-require")

local function setup()
    local nvim_tree = try_require("nvim-tree") or os.exit(1)

    nvim_tree.setup()
end

local function main()
    setup()
end

main()


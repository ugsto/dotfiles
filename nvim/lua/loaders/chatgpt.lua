local try_require = require("utils.try-require") or os.exit(1)

local function setup()
    local chatgpt = try_require("chatgpt") or os.exit(1)

    chatgpt.setup()
end

local function main()
    setup()
end

main()


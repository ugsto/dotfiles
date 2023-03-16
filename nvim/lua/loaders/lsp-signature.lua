local try_require = require("utils.try-require")

local function setup()
    local lsp_signature = try_require("lsp_signature") or os.exit(1)
    local config = try_require("config.lsp-signature") or os.exit(1)

    lsp_signature.setup(config)
end

local function main()
    setup()
end

main()

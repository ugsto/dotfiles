local function setup()
    local lsp_signature = require("lsp_signature")
    local config = require("config.lsp-signature")

    lsp_signature.setup(config)
end

local function main()
    setup()
end

main()

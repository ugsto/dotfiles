local try_require = require("utils.try-require")
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

local function preflight()
    -- Install packer.nvim if it's not already installed
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.cmd("!git clone --depth 1 https://github.com/wbthomason/packer.nvim " .. install_path)

        -- Exit and restart Neovim so that the plugins are loaded
        vim.cmd("qall")
    end
end

local function setup()
    vim.api.nvim_create_autocmd(
        { "BufWritePost" },
        {
            callback = function()
                require("packer").compile()
            end
        }
    )

    local packer = try_require("packer") or os.exit(1)
    local packer_config = try_require("config.packer") or os.exit(1)

    packer.startup(packer_config(packer.use))
end

local function main()
    preflight()
    setup()
end

main()

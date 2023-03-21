local function preflight()
    local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.cmd("!git clone --depth 1 https://github.com/wbthomason/packer.nvim " .. install_path)

        vim.cmd("qall")
    end
end

local function setup()
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
            require("packer").compile()
        end,
    })

    local packer = require("packer")
    local packer_config = require("config.packer")

    packer.startup(packer_config(packer.use))
end

local function main()
    preflight()
    setup()
end

main()

local function setup()
    -- Require colorscheme
    local is_colorscheme_loaded, colorscheme = pcall(require, "onedark")

    if not is_colorscheme_loaded then
        error("Onedark colorscheme is not installed")
    end

    colorscheme.load()
end

local function main()
    setup()
end

main()

local try_require = require("utils.try-require")

local function dap_setup()
    local dap = try_require("dap") or os.exit(1)
    local python_dap = try_require("config.dap.python") or os.exit(1)

    dap.adapters.python = python_dap.adapters
    dap.configurations.python = python_dap.configurations
end

local function null_ls_setup()
    local null_ls = try_require("null-ls") or os.exit(1)
    local null_ls_config = try_require("config.null-ls") or os.exit(1)
    local sources_fn = null_ls_config.get_sources or os.exit(1)

    null_ls.setup({
        sources = sources_fn(null_ls.builtins)
    })
end

local function cmp_setup()
    local cmp = try_require("cmp") or os.exit(1)
    local cmp_lspconfig = try_require("cmp_nvim_lsp") or os.exit(1)
    local keymap_fn = try_require("config.keymap.cmp") or os.exit(1)

    cmp.setup({
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end
        },
        mapping = keymap_fn(cmp),
        sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" }
        }
    })

    cmp_lspconfig.setup()
end

local function mason_setup()
    local mason = try_require("mason") or os.exit(1)
    local mason_lspconfig = try_require("mason-lspconfig") or os.exit(1)

    mason.setup()
    mason_lspconfig.setup()
end

local function setup()
    local lspconfig = try_require("lspconfig") or os.exit(1)
    local defaults = try_require("config.lspconfig") or os.exit(1)

    -- Setup cmp
    cmp_setup()

    -- Setup dap
    dap_setup()

    -- Setup null-ls
    null_ls_setup()

    -- Setup mason
    mason_setup()

    for _, lsp in ipairs(defaults.lsp) do
        lspconfig[lsp].setup(defaults.config)
    end
end

local function main()
    setup()
end

main()

local function dap_setup()
    local dap = require("dap")
    local python_dap = require("config.dap.python")

    dap.adapters.python = python_dap.adapters
    dap.configurations.python = python_dap.configurations
end

local function null_ls_setup()
    local null_ls = require("null-ls")
    local null_ls_config = require("config.null-ls")
    local sources_fn = null_ls_config.get_sources

    null_ls.setup({
        sources = sources_fn(null_ls.builtins),
    })
end

local function cmp_setup()
    local cmp = require("cmp")
    local cmp_lspconfig = require("cmp_nvim_lsp")
    local keymap_fn = require("config.keymap.cmp")

    cmp.setup({
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        mapping = keymap_fn(cmp),
        sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
        },
    })

    cmp_lspconfig.setup()
end

local function mason_setup()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    mason.setup()
    mason_lspconfig.setup()
end

local function setup()
    local lspconfig = require("lspconfig")
    local defaults = require("config.lspconfig")

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

local function config_opts()
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.hidden = true
    vim.opt.ignorecase = true
    vim.opt.smartcase = true
    vim.opt.splitbelow = true
    vim.opt.splitright = true
    vim.opt.termguicolors = true
    vim.opt.updatetime = 300
    vim.opt.timeoutlen = 500
    vim.opt.clipboard = "unnamedplus"
    vim.opt.mouse = ""
    vim.opt.expandtab = true
    vim.opt.shiftwidth = 4
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.scrolloff = 8
    vim.opt.sidescrolloff = 8
    vim.opt.sidescroll = 1
    vim.opt.wrap = false
end

return config_opts

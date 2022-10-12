local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.cmd('!git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]]

local packer = require('packer')
local use = packer.use
packer.startup(function()
  -- META
  use 'wbthomason/packer.nvim'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use {
    'hrsh7th/cmp-nvim-lsp',
    requires = {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/vim-vsnip',
      'hrsh7th/vim-vsnip-integ',
      'onsails/lspkind-nvim'
    }
  }
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }

  -- MARKDOWN
  use {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install'
  }

  -- DEV-TOOLS
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }
  use 'lukas-reineke/indent-blankline.nvim'
  use { 'tpope/vim-fugitive' }
  use { 'jiangmiao/auto-pairs' }
  use { 'voldikss/vim-floaterm' }
  use { 'chrisbra/Colorizer' }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
    tag = 'nightly',
    config = function() require('plugin.nvim-tree') end
  }

  -- COLORSCHEME
  use {
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
      require("catppuccin").setup()
      vim.api.nvim_command "colorscheme catppuccin"
    end
  }
end)

{
  plugins.lazy.enable = true;
  imports = [
    ./modules/colorscheme.nix
    ./modules/plugin/lsp/conform.nix
    ./modules/plugin/lsp/lsp.nix
    ./modules/plugin/lsp/rustaceanvim.nix
    ./modules/plugin/lsp/treesitter.nix
    ./modules/plugin/utils/cmp.nix
    ./modules/plugin/utils/gitsigns.nix
    ./modules/plugin/utils/guess-indent.nix
    ./modules/plugin/utils/mini.nix
    ./modules/plugin/utils/snacks.nix
    ./modules/plugin/utils/whichkey.nix
    ./keymaps.nix
    ./options.nix
  ];
}

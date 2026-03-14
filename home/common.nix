{
  inputs,
  pkgs,
  pkgs-unstable,
  pkgs-custom,
  ...
}:
{
  home.stateVersion = "25.11";

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";
  catppuccin.accent = "blue";

  home.packages = with pkgs; [
    lazygit
    android-file-transfer
    zbar
    dust
    bat
    fd
    ripgrep
    eza
    fzf
    jaq
    tcpdump
    light
    pavucontrol
    tor
    torsocks
    bc
    kubectl
    kubernetes-helm
    k9s
    zotero
    libreoffice
    zoom-us
    trilium-desktop

    pkgs-unstable.devenv
    pkgs-unstable.kind
    pkgs-unstable.wasistlos
    pkgs-unstable.freetube
    pkgs-unstable.antigravity
    pkgs-unstable.claude-code
    pkgs-unstable.gemini-cli
    pkgs-unstable.codex
    vscode

    pkgs-custom.nvim
    pkgs-custom.betterbird

    nerd-fonts.fira-code
    font-awesome
    freefont_ttf
    liberation_ttf
  ];
  fonts.fontconfig.enable = true;
  xdg.mime.enable = true;
  xdg.desktopEntries = { };

  programs.fzf.enableBashIntegration = true;
  programs.home-manager.enable = true;

  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./bash.nix
    ./chromium.nix
    ./librewolf.nix
    ./matrix.nix
    ./obs.nix
    ./starship.nix
    ./syncthing.nix
    ./tmux.nix
    ./wofi.nix
  ];
}

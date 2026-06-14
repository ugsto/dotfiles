{
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
    yazi
    drawio

    pkgs-unstable.devenv
    pkgs-unstable.kind
    pkgs-unstable.freetube
    pkgs-unstable.ferdium
    pkgs-unstable.openscad
    pkgs-unstable.freecad
    pkgs-unstable.opencode
    pkgs-unstable.solvespace
    pkgs-unstable.tor-browser
    pkgs-unstable.arduino
    pkgs-unstable.blender

    pkgs-custom.nvim
    pkgs-custom.betterbird

    nerd-fonts.fira-code
    font-awesome
    freefont_ttf
    liberation_ttf

    pkgs.ruff
    pkgs.nixfmt-rfc-style
    pkgs.jq
    pkgs.stylua
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.shellharden
    pkgs.bicep
  ];
  fonts.fontconfig.enable = true;
  xdg.mime.enable = true;
  xdg.desktopEntries = { };

  programs.fzf.enableBashIntegration = true;
  programs.home-manager.enable = true;

  imports = [
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

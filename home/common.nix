{
  inputs,
  pkgs,
  pkgs-unstable,
  system,
  ...
}:
{
  home.stateVersion = "25.11";
  home.packages = with pkgs; [
    chromium
    thunderbird
    lazygit
    wl-clipboard-rs
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
    grimblast
    light
    pavucontrol
    tor
    torsocks
    bc
    kubectl
    k9s
    zotero
    libreoffice

    pkgs-unstable.devenv
    pkgs-unstable.kind
    pkgs-unstable.wasistlos

    inputs.nvim.packages.${system}.default
  ];
  fonts.fontconfig.enable = true;

  programs.fzf.enableBashIntegration = true;
  programs.home-manager.enable = true;

  imports = [
    ./bash.nix
    ./librewolf.nix
    ./matrix.nix
    ./obs.nix
    ./starship.nix
    ./syncthing.nix
    ./tmux.nix
    ./wofi.nix
  ];
}

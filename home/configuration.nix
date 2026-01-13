{
  inputs,
  pkgs,
  pkgs-unstable,
  system,
  username,
  ...
}:
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
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

    sunshine
    dolphin-emu
    transmission_4
    bottles

    (retroarch.withCores (
      cores: with cores; [
        dolphin
        bsnes
      ]
    ))

    pkgs-unstable.devenv
    pkgs-unstable.kind
    pkgs-unstable.wasistlos

    inputs.nvim.packages.${system}.default
  ];
  fonts.fontconfig.enable = true;

  programs.fzf.enableBashIntegration = true;
  programs.home-manager.enable = true;

  imports = [
    ./alacritty.nix
    ./bash.nix
    ./sway.nix
    ./librewolf.nix
    ./matrix.nix
    ./obs.nix
    ./starship.nix
    ./syncthing.nix
    ./tmux.nix
    ./wofi.nix
  ];
}

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
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    chromium
    thunderbird
    lazygit
    xsel
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
    wasistlos

    pkgs-unstable.legcord
    pkgs-unstable.devenv
    pkgs-unstable.zoom-us
    pkgs-unstable.bottles
    pkgs-unstable.freetube

    inputs.nvim.packages.${system}.default
  ];
  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  imports = [
    ./alacritty.nix
    ./bash.nix
    ./hyprland.nix
    ./librewolf.nix
    ./matrix.nix
    ./obs.nix
    ./starship.nix
    ./syncthing.nix
    ./tmux.nix
    ./vscode.nix
    ./wofi.nix
  ];
}

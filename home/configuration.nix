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
  home.stateVersion = "24.11";
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
    pkgs-unstable.legcord
    pkgs-unstable.devenv
    obs-studio
    pkgs-unstable.zoom-us

    inputs.nvim.packages.${system}.default

    # Fonts
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
        "JetBrainsMono"
      ];
    })

    (retroarch.override {
      cores = with libretro; [
        gpsp
        melonds
      ];
    })
  ];

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  imports = [
    ./alacritty.nix
    ./bash.nix
    ./hyprland.nix
    ./librewolf.nix
    ./matrix.nix
    ./starship.nix
    ./syncthing.nix
    ./tmux.nix
    ./vscode.nix
    ./wofi.nix
  ];
}

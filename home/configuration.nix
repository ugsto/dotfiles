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
  home.homeDirectory = "/home/kurisu";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    pkgs-unstable.anydesk
    librewolf
    chromium
    thunderbird
    keepassxc
    lazygit
    xsel
    wl-clipboard-rs
    android-file-transfer
    zbar

    inputs.ugnvim.packages.${system}.default

    # Fonts
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
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
    ./eww
    ./hyprland.nix
    # ./librewolf.nix
    ./starship.nix
    ./tmux.nix
    ./wofi.nix
  ];
}

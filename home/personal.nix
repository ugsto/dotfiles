{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./common.nix
    ./gaming.nix
    ./sway.nix
    ./alacritty.nix
  ];

  home.packages = [
    pkgs.polkit_gnome
    pkgs.bambu-studio
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
}

{
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

  home.username = username;
  home.homeDirectory = "/home/${username}";
}

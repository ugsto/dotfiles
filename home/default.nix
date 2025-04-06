{ config, pkgs, ... }:

{
  home.username = "kurisu";
  home.homeDirectory = "/home/kurisu";

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    librewolf
    thunderbird
    keepassxc
    lazygit
  ];

  programs.home-manager.enable = true;
}

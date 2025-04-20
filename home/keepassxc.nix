{ pkgs-unstable, ... }:
{
  programs.keepassxc = {
    enable = true;
    package = pkgs-unstable.keepassxc;
  };
}

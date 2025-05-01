{ pkgs-unstable, ... }:
{
  home.packages = with pkgs-unstable; [
    element-desktop
  ];
}

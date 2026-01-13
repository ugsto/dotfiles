{ pkgs, ... }:
{
  targets.genericLinux.enable = true;
  wayland.windowManager.sway = {
    package = null;
  };
  home.packages = [
    pkgs.desktop-file-utils
  ];
}

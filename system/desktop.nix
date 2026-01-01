{
  pkgs,
  lib,
  username,
  ...
}:
{
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gvfs.enable = true;
  programs.hyprland.enable = true;
  programs.light.enable = true;
  services.printing.enable = false;
  users.users.${username}.extraGroups = [ "video" ];

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = lib.mkForce [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      # pkgs.xdg-desktop-portal-gnome
    ];
  };
}

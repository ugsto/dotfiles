{
  pkgs,
  lib,
  username,
  ...
}:
{
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "greeter";
        };
      };
    };
    gvfs.enable = true;
    printing.enable = false;
    flatpak.enable = true;
    dbus.enable = true;
  };

  programs = {
    sway.enable = true;
    light.enable = true;
    gamemode.enable = true;
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    dconf.enable = true;
  };

  users.users.${username}.extraGroups = [ "video" ];
  xdg.portal = {
    enable = true;
    extraPortals = lib.mkForce [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };
}

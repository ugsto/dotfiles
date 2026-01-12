{
  pkgs,
  lib,
  username,
  ...
}:
{
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  services.gvfs.enable = true;
  programs.hyprland.enable = true;
  programs.light.enable = true;
  services.printing.enable = false;
  users.users.${username}.extraGroups = [ "video" ];

  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    gnome-themes-extra
    adwaita-icon-theme
  ];

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

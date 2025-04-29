{ username, ... }:
{
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gvfs.enable = true;
  programs.hyprland.enable = true;
  programs.light.enable = true;

  users.users.${username}.extraGroups = [ "video" ];
}

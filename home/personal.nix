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
  ];

  services.flatpak.enable = true;
  services.flatpak.packages = [
    "com.bambulab.BambuStudio"
    "io.github.tobagin.karere"
  ];
  services.flatpak.remotes = [
    {
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.sessionVariables = {
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share";
    GTK_IM_MODULE = "cedilla";
    QT_IM_MODULE = "cedilla";
    IBUS_ENABLE_SYNC_MODE = "1";
  };
}

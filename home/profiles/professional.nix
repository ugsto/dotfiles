{
  pkgs,
  pkgs-unstable,
  username,
  ...
}:
{
  imports = [
    ../common.nix
    ../sway.nix
    ../alacritty.nix
  ];

  home = {
    packages = [
      pkgs.polkit_gnome
      pkgs-unstable.antigravity-cli
    ];
    inherit username;
    homeDirectory = "/home/${username}";
    sessionVariables = {
      XDG_DATA_DIRS = "$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share";
      GTK_IM_MODULE = "cedilla";
      QT_IM_MODULE = "cedilla";
      IBUS_ENABLE_SYNC_MODE = "1";
    };
  };
}

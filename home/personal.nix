{
  pkgs,
  pkgs-unstable,
  username,
  ...
}:
{
  imports = [
    ./common.nix
    ./sway.nix
    ./alacritty.nix
  ];

  # programs.antigravity-cli.enable = true;

  home = {
    packages = [
      pkgs.polkit_gnome
      pkgs-unstable.opencode
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

  services.flatpak = {
    enable = true;
    packages = [
      "com.bambulab.BambuStudio"
      "io.github.tobagin.karere"
      "org.skytemple.SkyTemple"
      "io.github.marco_calautti.DeltaPatcher"
    ];
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
  };
}

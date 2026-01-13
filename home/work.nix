{
  pkgs,
  lib,
  username,
  ...
}:
{
  imports = [
    ./common.nix
    ./sway.nix
    ./alacritty.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  targets.genericLinux.enable = true;

  programs.alacritty.package =
    let
      nixgl = pkgs.nixgl.auto.nixGLDefault;
    in
    pkgs.runCommand "alacritty-nixgl"
      {
        buildInputs = [ pkgs.makeWrapper ];
        meta.mainProgram = "alacritty";
      }
      ''
        mkdir -p $out/bin
        ln -s ${pkgs.alacritty}/share $out/share
        makeWrapper ${nixgl}/bin/nixGL $out/bin/alacritty \
          --add-flags "${pkgs.alacritty}/bin/alacritty"
      '';

  xdg.enable = true;
  xdg.mime.enable = true;

  home.sessionPath = [
    "$HOME/.nix-profile/bin"
    "$HOME/.local/bin"
  ];
  home.sessionVariables = lib.mkForce {
    XDG_DATA_DIRS = "$HOME/.nix-profile/share:$HOME/.local/share:$XDG_DATA_DIRS:/usr/local/share:/usr/share";
  };
}

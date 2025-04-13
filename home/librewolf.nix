{ pkgs, lib, ... }:
let
  nur-no-pkgs = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/main.tar.gz";
    sha256 = "dd4348743795c88e274767effef52f9709c40e19023c6f6278ec2e5ce8ff60c3";
  }) { };
in
{
  imports = lib.attrValues nur-no-pkgs.repos.rycee.hmModules.rawModules;

  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
  #   profiles.kurisu.extensions = {
  #     packages = with nur-no-pkgs.repos.rycee.firefox-addons; [
  #       ublock-origin
  #       canvasblocker
  #       search-by-image
  #     ];
  #     settings = {
  #       "webgl.disabled" = false;
  #       "privacy.clearOnShutdown.history" = false;
  #       "privacy.clearOnShutdown.downloads" = false;
  #     };
  #   };
  # };
}

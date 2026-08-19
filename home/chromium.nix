{ pkgs-unstable, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs-unstable.chromium;
    commandLineArgs = [
      "--ozone-platform-hint=auto"
    ];
    extensions = [
    ];
  };
}

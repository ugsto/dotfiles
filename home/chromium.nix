{ pkgs-unstable, ... }:
{
  home.packages = [ pkgs-unstable.keepassxc ];

  programs.chromium = {
    enable = true;
    package = pkgs-unstable.chromium;
    commandLineArgs = [
      "--ozone-platform-hint=auto"
    ];
    extensions = [
    ];

    nativeMessagingHosts = [
      pkgs-unstable.keepassxc
    ];
  };
}

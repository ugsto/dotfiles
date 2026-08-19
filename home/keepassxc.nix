{ pkgs-unstable, ... }:
{
  programs.keepassxc = {
    enable = true;
    package = pkgs-unstable.keepassxc;
    autostart = true;
    settings = {
      Browser.Enabled = true;
      FdoSecrets.Enabled = true;
    };
  };
}

{ pkgs-unstable, ... }:
{
  programs.keepassxc = {
    enable = true;
    package = pkgs-unstable.keepassxc;
    autostart = true;
    settings = {
      Browser = {
        Enabled = true;
        UpdateBinaryPath = false;
      };
      FdoSecrets.Enabled = true;
    };
  };
}

{ config, pkgs-unstable, ... }:
{
  programs.keepassxc = {
    enable = true;
    package = pkgs-unstable.keepassxc;
    autostart = true;
    settings = {
      Browser = {
        Enabled = true;
        UpdateBinaryPath = false;
        CustomBrowserType = 1;
        CustomBrowserLocation = "${config.home.homeDirectory}/.config/net.imput.helium/NativeMessagingHosts";
        UseCustomBrowser = true;
      };
      FdoSecrets.Enabled = true;
      GUI = {
        AdvancedSettings = true;
        ApplicationTheme = "dark";
        CompactMode = true;
        HidePasswords = true;
      };
    };
  };

  xdg.configFile."net.imput.helium/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json".source =
    "${pkgs-unstable.keepassxc}/etc/chromium/native-messaging-hosts/org.keepassxc.keepassxc_browser.json";
}

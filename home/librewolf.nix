{ pkgs-unstable, ... }:
{

  home.packages = [ pkgs-unstable.keepassxc ];
  programs.librewolf = {
    enable = true;
    package = pkgs-unstable.librewolf;
    nativeMessagingHosts = [ pkgs-unstable.keepassxc ];
    profiles.kurisu = {
      search.engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];

          icon = "${pkgs-unstable.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
      };
      search.force = true;

      settings = {
        "dom.security.https_only_mode" = true;
        "browser.download.panel.shown" = true;
        "identity.fxaccounts.enabled" = false;
        "signon.rememberSignons" = false;
      };

      extensions = {
        force = true;
        packages = with pkgs-unstable.nur.repos.rycee.firefox-addons; [
          ublock-origin
          canvasblocker
          search-by-image
          tridactyl
          youtube-shorts-block
          keepassxc-browser
        ];
      };
    };
  };
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

  xdg.desktopEntries.librewolf = {
    name = "LibreWolf";
    genericName = "Web Browser";
    exec = "env -u LD_LIBRARY_PATH librewolf --name librewolf %U";
    icon = "librewolf";
    terminal = false;
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
    settings = {
      StartupWMClass = "librewolf";
    };
    actions = {
      "new-private-window" = {
        name = "New Private Window";
        exec = "env -u LD_LIBRARY_PATH librewolf --private-window %U";
      };
      "new-window" = {
        name = "New Window";
        exec = "env -u LD_LIBRARY_PATH librewolf --new-window %U";
      };
      "profile-manager-window" = {
        name = "Profile Manager";
        exec = "env -u LD_LIBRARY_PATH librewolf --ProfileManager";
      };
    };
  };
}

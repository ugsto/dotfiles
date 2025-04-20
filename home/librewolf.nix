{ pkgs-unstable, ... }:
{
  programs.librewolf = {
    enable = true;
    # nativeMessagingHosts = [ pkgs-unstable.keepassxc ];
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

      extensions = with pkgs-unstable.nur.repos.rycee.firefox-addons; [
        ublock-origin
        canvasblocker
        search-by-image
        tridactyl
        youtube-shorts-block
        keepassxc-browser
      ];
    };
  };
}

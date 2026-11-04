{ pkgs, ... }:
{
  plugins.rustaceanvim = {
    enable = true;
    settings = {
      server = {
        cmd = [ "${pkgs.rust-analyzer}/bin/rust-analyzer" ];
        default_settings = {
          rust-analyzer = {
            check = {
              command = "clippy";
            };
            inlayHints = {
              lifetimeElisionHints = {
                enable = "always";
              };
            };
          };
        };
        standalone = false;
      };
    };
  };
}

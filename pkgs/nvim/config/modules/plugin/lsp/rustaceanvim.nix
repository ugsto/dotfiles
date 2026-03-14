{
  plugins.rustaceanvim = {
    enable = true;
    settings = {
      server = {
        cmd = [
          "nix"
          "develop"
          "--command"
          "rust-analyzer"
        ];
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

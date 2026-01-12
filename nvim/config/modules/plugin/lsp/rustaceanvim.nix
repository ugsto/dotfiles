{
  plugins.rustaceanvim = {
    enable = true;
    settings = {
      server = {
        standalone = false;
        default_settings = {
          rust-analyzer = {
            cargo = {
              allFeatures = true;
              allTargets = true;
              loadOutDirsFromCheck = true;
              runBuildScripts = true;
              sysroot = "discover";
              buildScripts = {
                enable = true;
                useRustcWrapper = true;
              };
            };
            procMacro = {
              enable = true;
              attributes = {
                enable = true;
              };
            };
            diagnostics = {
              enable = true;
            };
            check = {
              command = "clippy";
            };
          };
        };
      };
    };
  };
}

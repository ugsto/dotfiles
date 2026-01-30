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
              loadOutDirsFromCheck = true;
              runBuildScripts = true;
            };
            procMacro = {
              enable = true;
            };
            checkOnSave = true;
            check = {
              command = "clippy";
            };
          };
        };
      };
    };
  };
}

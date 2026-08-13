{
  plugins.codecompanion = {
    enable = true;
    settings = {
      adapters = {
        http = {
          openrouter = {
            __raw = ''
              function()
                return require("codecompanion.adapters").extend("openrouter", {
                  env = {
                    api_key = "cmd:echo $OPENROUTER_NVIM_API_KEY",
                  },
                  schema = {
                    model = {
                      default = "deepseek/deepseek-v4-flash-0731",
                    },
                  },
                })
              end
            '';
          };
        };
      };
      strategies = {
        chat = {
          adapter = "openrouter";
        };
        inline = {
          adapter = "openrouter";
        };
      };
    };
  };
}

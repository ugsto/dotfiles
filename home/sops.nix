{
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ../secrets/secret.yaml;

    secrets = {
      "deepseek_api_key" = { };
      "minimax_api_key" = { };
      "openrouter_api_key" = { };
      "openrouter_nvim_api_key" = { };
      "zai_api_key" = { };
    };
  };

  home.sessionVariables = {
    DEEPSEEK_API_KEY = "$(<${config.sops.secrets.deepseek_api_key.path})";
    OPENROUTER_API_KEY = "$(<${config.sops.secrets.openrouter_api_key.path})";
    ZAI_API_KEY = "$(<${config.sops.secrets.zai_api_key.path})";
    MINIMAX_API_KEY = "$(<${config.sops.secrets.minimax_api_key.path})";
    OPENAI_CODEX_API_KEY = "$(jq -r .tokens.access_token ~/.codex/auth.json 2>/dev/null)";
    OPENROUTER_NVIM_API_KEY = "$(<${config.sops.secrets.openrouter_nvim_api_key.path})";
  };
}

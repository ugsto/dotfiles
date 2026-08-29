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
      "openrouter_nvim_api_key" = { };
    };
  };

  home.sessionVariables = {
    DEEPSEEK_API_KEY = "$(<${config.sops.secrets.deepseek_api_key.path})";
    OPENROUTER_NVIM_API_KEY = "$(<${config.sops.secrets.openrouter_nvim_api_key.path})";
  };
}

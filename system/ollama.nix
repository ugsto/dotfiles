{ pkgs-unstable, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs-unstable.ollama-vulkan;
    environmentVariables = {
      OLLAMA_VULKAN = "1";
    };
  };

  environment.systemPackages = [ pkgs-unstable.llama-cpp-vulkan ];
}

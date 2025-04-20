{
  services.ollama = {
    enable = true;
    loadModels = [
      "deepseek-r1:1.5b"
    ];
    acceleration = "rocm";
  };
}

{ pkgs, ... }: {
  programs.retroarch = {
    enable = true;
    cores = {
      citra.enable = true;
      desmume.enable = true;
    };
  };

  home = {
    packages = with pkgs; [
      steam
    ];
  };

}

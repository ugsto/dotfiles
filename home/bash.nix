{ config, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "eza --color=auto --icons --group-directories-first";
      cat = "bat";
      k = "kubectl";
    };
  };
}

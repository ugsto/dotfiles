{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sunshine
    dolphin-emu
    transmission_4
    bottles
    (retroarch.withCores (
      cores: with cores; [
        dolphin
        bsnes
      ]
    ))
  ];
}

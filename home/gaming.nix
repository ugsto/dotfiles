{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sunshine
    dolphin-emu
    transmission_4
    bottles
    veloren
    aseprite
    (retroarch.withCores (
      cores: with cores; [
        dolphin
        bsnes
      ]
    ))
  ];
}

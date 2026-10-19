pkgs: {
  caveman = pkgs.fetchFromGitHub {
    owner = "JuliusBrussee";
    repo = "caveman";
    rev = "2e08b9177c07bb7249a8a2d1a6758e5db281d002"; # v3.2.0
    hash = "sha256-przOot/S0VLw2aP3tOdxF27mZHMp0NQhyTls0eDAjjs=";
  };
  ponytail = pkgs.fetchFromGitHub {
    owner = "DietrichGebert";
    repo = "ponytail";
    rev = "9b58c1ffb790c075ca32e70a89cf1d80588f4abf"; # v5.1.0
    hash = "sha256-S2gHV4/c8XPDqpf0jS8Q5r22//6skZjITf2T9CVhVRE=";
  };
  mattpocock-skills = pkgs.fetchFromGitHub {
    owner = "mattpocock";
    repo = "skills";
    rev = "24fe0ef7737efae15c87225755e9f6f5965e4888"; # v1.3.1
    hash = "sha256-/mAmj7QFdyOWhLmy3Rt2/Hfsh5qwirTRax7hmQffFdo=";
  };
}

{
  description = "My dotfiles!";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nvf.url = "github:notashelf/nvf";
  };
  outputs = { self, nixpkgs, home-manager, nvf, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
    nixosConfigurations = {
      main = lib.nixosSystem {
        inherit system;
	modules = [ ./configuration.nix ];
      };
    };
    homeConfigurations = {
      main = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
	modules = [
	  ./home
	  ./home/bash.nix
	];
      };
    };
    packages.${system}.default =
      (nvf.lib.neovimConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
	modules = [ ./nvf-configuration.nix ];
      }).neovim;
  };
}

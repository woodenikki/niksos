{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using nixos-23.11 branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager input
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # Correctly import user home configuration
          home-manager.users.nik = import ./home.nix;
        }
      ];
    };

    homeConfigurations = {
      nik = home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        homeDirectory = "/home/nik";
        username = "nik";
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        configuration = import ./home.nix;
      };
    };
  };
}

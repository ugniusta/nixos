{
  description = "Nixos config flake";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    zen-browser = {
      url = "github:NikSneMC/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    { nixpkgs-unstable, nixpkgs-stable, ... }@inputs:
    let
      flakeDir = inputs.self;
    in
    {
      nixosConfigurations = {
        Legion-5 = nixpkgs-unstable.lib.nixosSystem {
          specialArgs = {
            inherit inputs flakeDir;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/legion-5/configuration.nix
          ];
        };

        Nasys = inputs.nixpkgs-stable.lib.nixosSystem {
          specialArgs = {
            inherit inputs flakeDir;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/nasys/configuration.nix
            (
              { ... }:
              {
                nix.maxJobs = 2;
                nix.buildCores = 4;
              }
            )
          ];
        };

        Linas = nixpkgs-stable.lib.nixosSystem {
          specialArgs = {
            inherit inputs flakeDir;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/linas/configuration.nix
          ];
        };
      };
    };
}

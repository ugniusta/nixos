{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:NikSneMC/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      flakeDir = inputs.self;
    in
    {
      nixosConfigurations = {
        Legion-5 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs flakeDir;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/legion-5/configuration.nix
          ];
        };

        Nasys = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs flakeDir;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/nasys/configuration.nix
          ];
        };

        Linas = nixpkgs.lib.nixosSystem {
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

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

  outputs = { nixpkgs, home-manager, zen-browser, ... } @ inputs: {
    nixosConfigurations = {
      Legion-5 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = [
          ./hosts/legion-5/configuration.nix
	        ./modules/core
          ./modules/desktop
          ./modules/development
          ./modules/virtualization

          home-manager.nixosModules.home-manager {
	          home-manager.useGlobalPkgs = true;
	          home-manager.useUserPackages = true;
	          home-manager.users.ugnius = import ./home/home.nix;
            home-manager.extraSpecialArgs = { inherit inputs; system = "x86_64-linux"; };
	        }
        ];

      };

      Nasys = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = [
          ./hosts/nasys/configuration.nix
        ];
    };
  };
}

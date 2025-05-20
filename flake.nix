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
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, zen-browser, fenix, ... } @ inputs: {
    packages.x86_64-linux.default = fenix.packages.x86_64-linux.stable.toolchain;
    nixosConfigurations = {
      Legion-5 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = [
          ./hosts/legion-5/configuration.nix
	        ./modules/core
          ./modules/desktop
          ./modules/development
          # ./modules/virtualization

          home-manager.nixosModules.home-manager {
	          home-manager.useGlobalPkgs = true;
	          home-manager.useUserPackages = true;
	          home-manager.users.ugnius = import ./home/home.nix;
            home-manager.extraSpecialArgs = { inherit inputs; system = "x86_64-linux"; };
	        }

          ({ pkgs, ...}: {
            nixpkgs.overlays = [ fenix.overlays.default ];
            environment.systemPackages = with pkgs; [
            #   (fenix.stable.withComponents [
            #     "cargo"
            #     "clippy"
            #     "rust-src"
            #     "rustc"
            #     "rustfmt"
            #   ])
              rust-analyzer-nightly
            ];
          })
        ];
      };
    };
  };
}

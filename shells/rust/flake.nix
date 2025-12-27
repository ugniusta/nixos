# {
#   description = "My Cool Rust App";
#   inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; };
#   outputs = { self, nixpkgs }:
#     let
#       system = "x86_64-linux";
#       pkgs = import nixpkgs { inherit system; };
#     in {
#       devShells.${system}.default = pkgs.mkShell {
#         packages = [ pkgs.rustc pkgs.cargo pkgs.rust-analyzer ];
#       };
#       packages.${system}.default = pkgs.rustPlatform.buildRustPackage {
#         pname = "myapp";
#         version = "0.0.1";
#         cargoLock.lockFile = ./Cargo.lock;
#         src = pkgs.lib.cleanSource ./.;
#       };
#     };
# }

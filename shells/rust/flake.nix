{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    overrides = (builtins.fromTOML (builtins.readFile (self + "/rust-toolchain.toml")));
    espup = pkgs.rustPlatform.buildRustPackage rec {
      pname = "espup";
      version = "0.14.0";

      src = pkgs.fetchFromGitHub {
        owner = "esp-rs";
	repo = "espup";
	rev = "v${version}";
	hash = "sha256-LMzVxLwl24bw1o+OYiNcxm+KrnDyrg8tjkWhwsYYKzs=";
      };

      useFetchCargoVendor = true;
      cargoHash = "sha256-4ModbVBymWLCtLlX6SBSWm8M2ZdcqakRqB+uHRQPArM=";

      preCheck = "export HOME=$(mktemp -d)";

      nativeBuildInputs = with pkgs; [
         perl
      ];

      checkFlags = [
        "--skip=toolchain::rust::tests::test_xtensa_rust_parse_version"
      ];
    };

    esp-generate = pkgs.rustPlatform.buildRustPackage rec {
      pname = "esp-generate";
      version = "0.2.2";

      src = pkgs.fetchFromGitHub {
        owner = "esp-rs";
	repo = "esp-generate";
	rev = "v${version}";
	hash = "sha256-qDlEI9cav2RSsYinIlW4VqmCtUW+vAgFJOE2miFAVVo=";
      };

      useFetchCargoVendor = true;
      cargoHash = "sha256-fBTJBHlbIvj1JYJBrtZdaIU1ztB3yE3LF6GxTfGXWTM=";
    };

  in {
    devShells.${system}.default =
      pkgs.mkShell {
        buildInputs = with pkgs; [
	  rustup
	  espup
	  esp-generate
	  espflash
	];

        RUSTC_VERSION = overrides.toolchain.channel;
        LIBCLANG_PATH = pkgs.lib.makeLibraryPath [ pkgs.llvmPackages_latest.libclang.lib ];
        ESPUP_EXPORT_FILE = "export-esp.sh";

	shellHook = ''
          export PATH=$PATH:''${CARGO_HOME:-~/.cargo}/bin
          export PATH=$PATH:''${RUSTUP_HOME:-~/.rustup}/toolchains/$RUSTC_VERSION-x86_64-unknown-linux-gnu/bin

	  if ! [ -f "$ESPUP_EXPORT_FILE" ]; then
	    espup install
	  fi

          source "$ESPUP_EXPORT_FILE"

          exec nu
	'';

      };
  };
}

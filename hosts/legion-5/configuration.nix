{ config, pkgs, flakeDir, inputs, ... }: {

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  imports = [
    ./hardware-configuration.nix
    "${flakeDir}/modules/core"
    "${flakeDir}/modules/nvidia"
    "${flakeDir}/modules/desktop"
    "${flakeDir}/modules/development"
    "${flakeDir}/modules/virtualization"

    inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.ugnius = import "${flakeDir}/home/home.nix";
      home-manager.extraSpecialArgs = { inherit inputs; system = "x86_64-linux"; };
    }
  ];

  environment.systemPackages = with pkgs; [
    lenovo-legion
  ];

  boot.kernelModules = [ "lenovo-legion-module" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ lenovo-legion-module ];

  networking.hostName = "Legion-5";

  users.users.ugnius = {
     isNormalUser = true;
     description = "Ugnius Stašaitis";
     extraGroups = [ "networkmanager" "wheel" "dialout" ];
     packages = with pkgs; [
       kdePackages.kate
     ];
  };
}

{ config, pkgs, ... }: {

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  imports = [
    ./hardware-configuration.nix
    ../../modules/nvidia
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

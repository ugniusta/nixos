{ config, pkgs, ... }: {
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
}

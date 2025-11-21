{
  config,
  pkgs,
  flakeDir,
  inputs,
  ...
}:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  imports = [
    ./hardware-configuration.nix
    "${flakeDir}/modules/core"
    "${flakeDir}/modules/nvidia"
    "${flakeDir}/modules/desktop"
    "${flakeDir}/modules/development"
    "${flakeDir}/cachix.nix"
    "${flakeDir}/modules/virtualization"

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.ugnius = import "${flakeDir}/home/home.nix";
      home-manager.extraSpecialArgs = {
        inherit inputs;
        system = "x86_64-linux";
      };
    }
  ];

  core.adminUser.enable = false;
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    lenovo-legion
  ];

  boot.kernelModules = [ "lenovo-legion-module" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ lenovo-legion-module ];

  networking.hostName = "Legion-5";

  users.users.ugnius = {
    isNormalUser = true;
    description = "Ugnius Stašaitis";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
    ];
  };

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.11.0.1/12" ];
      listenPort = 51820;
      privateKeyFile = "/etc/nixos/secrets/legion-5/wireguard/private.key";

      peers = [
        {
          publicKey = "r1kIoqXkQrcM+Ki0ZML91NORWnNcwEH99vnTFnTWIkM=";
          allowedIPs = [ "10.10.0.1/32" "10.11.0.2/32"];
          endpoint = "nasys.servers.stasaitis.me:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}

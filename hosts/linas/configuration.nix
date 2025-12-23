let
  hostname = "Linas";
  username = "linas";
in
{
  config,
  flakeDir,
  pkgs,
  lib,
  ...
}:
{

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  imports = [
    ./hardware-configuration.nix
    "${flakeDir}/modules/core"
    "${flakeDir}/modules/desktop/gaming"
  ];

  networking.hostName = "${hostname}";
  networking.networkmanager.enable = true;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  users.users."${username}" = {
    isNormalUser = true;
    description = "Linas Stašaitis";
    extraGroups = [ "networkmanager" ];
    packages = with pkgs; [
      lutris
      heroic
      libreoffice-qt-fresh
      vlc
    ];
  };

  users.users.admin =
    let
      machine = lib.strings.toLower "${hostname}";
    in
    {
      openssh.authorizedKeys.keyFiles = [
        "/etc/nixos/secrets/${machine}/ssh/legion-5_admin@Linas.pub"
        "/etc/nixos/secrets/${machine}/ssh/s24u_admin@Linas.pub"
      ];
    };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.13.0.1/12" ];
      listenPort = 51820;
      privateKeyFile = "/etc/nixos/secrets/linas/wireguard/private.key";

      peers = [
        {
          publicKey = "r1kIoqXkQrcM+Ki0ZML91NORWnNcwEH99vnTFnTWIkM=";
          # allowedIPs = [ "10.10.0.1/32" "10.11.0.1/32"];
          allowedIPs = [ "10.11.0.1/32"];
          endpoint = "nasys.servers.stasaitis.me:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # boot.kernelParams = [ "radeon.cik_support=0" "radeon.si_support=0" "amdgpu.cik_support=1" "amdgpu.si_support=1" ];
  # boot.kernelParams = [ "radeon.si_support=0" "amdgpu.si_support=1" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [
    "radeon.cik_support=0"
    "radeon.si_support=0"
    "amdgpu.cik_support=1"
    "amdgpu.si_support=1"
  ];

  # hardware.graphics.extraPackages = with pkgs; [ amdvlk ];
  # hardware.graphics.extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];

  services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.firefox.enable = true;

  services.xserver.enable = false;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.nix-ld.enable = true;

}

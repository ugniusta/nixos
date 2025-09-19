let username = "linas";
in
{ config, flakeDir, pkgs, ... }: {

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  imports = [
    ./hardware-configuration.nix
    ./${flakeDir}/modules/core
  ];

  networking.hostName = "Linas";

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  users.users."${username}"= {
     isNormalUser = true;
     description = "Linas Stašaitis";
     extraGroups = [ "networkmanager" ];
     packages = with pkgs; [
       lutris
       heroic
       libreoffice-qt-fresh
       git
     ];
  };

  users.users.root = {
    isSystemUser = true;
    openssh.authorizedKeys.keyFiles = [
      "/etc/nixos/secrets/${username}/ssh/legion-5_root@Linas.pub"
      "/etc/nixos/secrets/${username}/ssh/s24u_root@Linas.pub"
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # boot.kernelParams = [ "radeon.cik_support=0" "radeon.si_support=0" "amdgpu.cik_support=1" "amdgpu.si_support=1" ];
  # boot.kernelParams = [ "radeon.si_support=0" "amdgpu.si_support=1" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [ "radeon.cik_support=0" "radeon.si_support=0" "amdgpu.cik_support=1" "amdgpu.si_support=1" ];

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

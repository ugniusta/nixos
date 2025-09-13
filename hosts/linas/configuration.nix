let username = "linas";
in
{ config, pkgs, ... }: {

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "Linas";

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = [ "${username}" ];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "yes"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
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
     ];
    openssh.authorizedKeys.keyFiles = [
      "/etc/nixos/secrets/${username}/ssh/legion-5_linas@Linas.pub"
      "/etc/nixos/secrets/${username}/ssh/s24_linas@Linas.pub"
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

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

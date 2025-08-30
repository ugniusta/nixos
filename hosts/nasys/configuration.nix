let username = "nasys";
in { config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_12_hardened;

  networking.hostName = "Nasys";

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = [ "${username}" ];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  users.users.${username} = {
     isNormalUser = true;
     description = "Main NAS user";
     extraGroups = [ "wheel" ];
     openssh.authorizedKeys.keyFiles = [ "/etc/nixos/secrets/${username}/ssh/legion-5_nasys@Nasys.pub" ]; # TODO: Path var
  };
  nix.settings.trusted-users = [ "${username}" ];
}

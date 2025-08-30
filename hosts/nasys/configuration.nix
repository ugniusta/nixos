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
      PasswordAuthentication = true;
      AllowUsers = [ username ]; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  users.users."${username}" = {
     isNormalUser = true;
     description = "NAS";
     extraGroups = [ "wheel" ];
     openssh.authorizedKeys.keyFiles = [ "/etc/nixos/secrets/${username}/ssh/nasys.pub" ]; # TODO: Path var
  };
  nix.settings.trusted-users = [ username ];
}

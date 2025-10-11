let
  username = "nasys";
in
{
  inputs,
  flakeDir,
  pkgs,
  ...
}:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  imports = [
    "${flakeDir}/hosts/nasys/hardware-configuration.nix"
    "${flakeDir}/modules/core"
    "${flakeDir}/modules/server/zfs.nix"
    "${flakeDir}/modules/server/wireguard.nix"
    "${flakeDir}/modules/server/samba.nix"
  ];

  networking.hostName = "Nasys";
  networking.useNetworkd = true;
  systemd.network.enable = true;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = [ "${username}" ];
      # DenyUsers = [ "*@10.3.*.*" ]; # TODO: not robust enough.
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
    # services.openssh.extraConfig
  };

  users.users."${username}" = {
    isNormalUser = true;
    description = "Nas main user";
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keyFiles = [
      "/etc/nixos/secrets/${username}/ssh/legion-5_nasys@Nasys.pub"
      "/etc/nixos/secrets/${username}/ssh/s24u_nasys@Nasys.pub"
    ];
  };
  nix.settings.trusted-users = [ "${username}" ];

  services.fail2ban = {
    enable = true;
    # Ban IP after 5 failures
    maxretry = 5;
    ignoreIP = [
      "10.11.0.0/16"
      "192.168.0.0/16"
    ];
    bantime = "1m";
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };
  };
}

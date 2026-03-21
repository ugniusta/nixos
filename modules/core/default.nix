{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.core;
in
{
  options.core.adminUser.enable =
    with lib;
    mkOption {
      type = types.bool;
      default = true;
      description = "Enable the admin user.";
    };

  config = {
    users.users.admin = mkIf cfg.adminUser.enable {
      isNormalUser = true;
      group = "admin";
      description = "System administrator";
      extraGroups = [ "wheel" ];
      shell = pkgs.fish;
    };
    users.groups.admin = mkIf cfg.adminUser.enable {};
    nix.settings.trusted-users = mkIf cfg.adminUser.enable [ "admin" ];

    system.stateVersion = "25.05";

    time.timeZone = "Europe/Vilnius";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_NUMERIC = "lt_LT.UTF-8";
      LC_TIME = "lt_LT.UTF-8";
      LC_MONETARY = "lt_LT.UTF-8";
      LC_PAPER = "lt_LT.UTF-8";
      LC_ADDRESS = "lt_LT.UTF-8";
      LC_MEASUREMENT = "lt_LT.UTF-8";
    };

    services.xserver.xkb = {
      layout = "lt";
      variant = "us";
    };

    console.keyMap = "lt.baltic";

    nixpkgs.config.allowUnfree = true;

    programs.git.enable = true;
    programs.fish.enable = true;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
      "recursive-nix"
    ];
  };
}

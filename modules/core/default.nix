{
  config,
  pkgs,
  lib,
  ...
}:
  with lib;
  let cfg = config.core; in
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
      description = "System administrator";
      extraGroups = [ "wheel" ];
      shell = pkgs.fish;
    };

    system.stateVersion = "25.05";
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Vilnius";

    i18n.defaultLocale = "en_US.UTF-8";

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
    ];
  };
}

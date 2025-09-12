{ config, pkgs, inputs, ... }: {
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

  environment.systemPackages = with pkgs; [
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

{ inputs, config, pkgs, ... }: {
  home.username = "ugnius";
  home.homeDirectory = "/home/ugnius";

  home.packages = with pkgs; [
    ghostty
    nushell
    helix
    vscodium
    tmux
    saleae-logic-2

    bat

    cowsay

    ventoy-full
    testdisk

    lshw
    lm_sensors
    pciutils
    usbutils

    signal-desktop-bin
    beeper
    libreoffice-qt6-fresh
    vlc
    qbittorrent
    gimp
    drawio

    inputs.zen-browser.packages.${system}.beta
  ];

  programs.git = {
    enable = true;
    userName = "staugi";
    userEmail = "ugnius@dev.stasaitis.me";
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  home.file = {
    ".config/ghostty/config" = {
      source = ../config/ghostty/config;
      force = true;
    };
    ".config/helix/config.toml" = {
      source = ../config/helix/config.toml;
      force = true;
    };
    ".config/nushell/config.nu" = {
      source = ../config/nushell/config.nu;
      force = true;
    };
  };

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}

{ inputs,  pkgs, ... }: {
  home.username = "ugnius";
  home.homeDirectory = "/home/ugnius";

  home.packages = with pkgs; [
    starsector
    
    ghostty
    nushell
    fish
    helix
    vscodium
    saleae-logic-2
    zoxide

    bat
    zellij
    ripgrep
    fd
    gitui
    yazi
    hyperfine
    mprocs
    btop
    zoxide

    cowsay

    testdisk

    lshw
    lm_sensors
    pciutils
    usbutils
    remmina

    signal-desktop-bin
    beeper
    libreoffice-qt6-fresh
    vlc
    qbittorrent
    gimp
    drawio
    obs-studio

    inputs.zen-browser.packages.${system}.beta
    wireguard-tools 

    bazecor
    anki-bin
  ];

  programs.git = {
    enable = true;
    userName = "staugi";
    userEmail = "ugnius@dev.stasaitis.me";
  };

  programs.starship = {
    enable = true;
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
    ".config/zellij/config.kdl" = {
      source = ../config/zellij/config.kdl;
      force = true;
    };
    ".config/starship.toml" = {
      source = ../config/starship/starship.toml;
      force = true;
    };
    ".config/fish/config.fish" = {
      source = ../config/fish/config.fish;
      force = true;
    };
  };

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}

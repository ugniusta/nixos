{
  inputs,
  pkgs,
  ...
}:
{
  home.username = "ugnius";
  home.homeDirectory = "/home/ugnius";

  home.packages = with pkgs; [
    starsector

    ghostty
    nushell
    helix
    neovim
    opencode
    vscode
    saleae-logic-2
    zoxide
    comma
    python3

    bat
    zellij
    ripgrep
    fd
    gitui
    yazi
    hyperfine
    mprocs
    btop
    wget
    rpi-imager
    mediawriter
    unixtools.arp
    unixtools.column

    cowsay

    testdisk

    lshw
    lm_sensors
    pciutils
    usbutils
    remmina

    signal-desktop
    beeper

    libreoffice-qt6-fresh
    zotero
    obsidian
    zulu25
    wireshark

    vlc
    qbittorrent
    gimp
    drawio
    obs-studio

    inputs.zen-browser.packages.${stdenv.hostPlatform.system}.default
    wireguard-tools

    bazecor
    anki-bin
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "ugniusta";
        email = "programs.git.settings.user.name";
      };
    };
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

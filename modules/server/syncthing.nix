{ ... }:
{
  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
    openDefaultPorts = false;
    overrideDevices = false;
    overrideFolders = false;

    settings.options = {
      globalAnnounceEnabled = false;
      listenAddresses = [
        "tcp://10.10.0.1:22000"
        "quic://10.10.0.1:22000"
      ];
      localAnnounceEnabled = false;
      natEnabled = false;
      relaysEnabled = false;
    };
  };

  systemd.services.syncthing.unitConfig.RequiresMountsFor = "/mnt/nas/syncthing";

  systemd.tmpfiles.settings."10-syncthing" = {
    "/mnt/nas/syncthing".d = {
      user = "syncthing";
      group = "syncthing";
      mode = "0700";
    };
  };

  networking.firewall.extraInputRules = ''
    iifname "wg0" ip saddr 10.11.0.0/16 tcp dport { 8384, 22000 } accept
    iifname "wg0" ip saddr 10.11.0.0/16 udp dport 22000 accept
  '';
}

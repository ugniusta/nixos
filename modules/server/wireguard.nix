{ pkgs, ... }:
{
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  systemd.network.netdevs = {
    "50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
        MTUBytes = "1300";
      };
      wireguardConfig = {
        PrivateKeyFile = "/etc/nixos/secrets/nasys/wireguard/private.key";
        ListenPort = 51820;
      };
      wireguardPeers = [
        # Legion-5
        {
          PublicKey = "dEN7KtZqhkOw9jtmwMu7iDixYthcBZ0HqN+UILqNvFo=";
          AllowedIPs = [ "10.11.0.1/32" ];
        }
        # S24U
        {
          PublicKey = "yeAuEniGUGZMwGY/vlKYkFV40DF+qcyb2EEcejl62ng=";
          AllowedIPs = [ "10.11.0.2/32" ];
        }
        # Aido laptopas
        {
          PublicKey = "5GYWlehyKKyB8oKTsvE47guv/h4PQcgwzCpLHeQt8TE=";
          AllowedIPs = [ "10.12.0.1/32" ];
        }
        # Gundos laptopas
        {
          PublicKey = "3nIXAyfpg6eiQ4R37nmFzCer5PNh2XsePgvdHxKBoVw=";
          AllowedIPs = [ "10.12.1.1/32" ];
        }
      ];
    };
  };

  systemd.network.networks."wg0" = {
    matchConfig.Name = "wg0";
    address = [ "10.10.0.1/12" ];
  };
}

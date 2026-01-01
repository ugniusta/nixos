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
        # 1
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

        # 2
        # Aido laptopas
        {
          PublicKey = "5GYWlehyKKyB8oKTsvE47guv/h4PQcgwzCpLHeQt8TE=";
          AllowedIPs = [ "10.12.0.1/32" ];
        }
        # Aido S22U
        {
          PublicKey = "dFvGwCO/NjZVNdkHp096MO0Fz+HNwbdjPqZT1SMN/Vk=";
          AllowedIPs = [ "10.12.0.2/32" ];
        }

        # Gunda
        # Laptopas
        {
          PublicKey = "3nIXAyfpg6eiQ4R37nmFzCer5PNh2XsePgvdHxKBoVw=";
          AllowedIPs = [ "10.12.1.1/32" ];
        }
        # Flip 5
        # {
        #   PublicKey = "BBRKOv97SxvDsl205x4ubNhBhx53B+k2iwfwhKiatwY=";
        #   AllowedIPs = [ "10.12.1.2/32" ];
        # }
        # 
        {
          PublicKey = "QbEUEaY7i33v0oNlE6c5sz4ZkhtyIoqnD6dzShrCfBg=";
          AllowedIPs = [ "10.12.1.3/32" ];
        }

        # 3
        # Linas
        # Palėpė
        {
          PublicKey = "7nnEafjMThY49aaDsFXILjOo/m/CSe1F3BTx0qxFbkY=";
          AllowedIPs = [ "10.13.0.1/32" ];
        }
      ];
    };
  };

  systemd.network.networks."wg0" = {
    matchConfig.Name = "wg0";
    address = [ "10.10.0.1/12" ];
    networkConfig = {
      # IPMasquerade = "ipv4";
      IPv4Forwarding = true;
    };
  };
}

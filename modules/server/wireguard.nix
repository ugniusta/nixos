{pkgs, ...}: {
  networking.nat.enable = true;
  networking.nat.externalInterface = "eth0";
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.10.0.1/12" ];

      listenPort = 51820;

      # postSetup = ''
      #   ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      # '';

      # postShutdown = ''
      #   ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      # '';

     privateKeyFile = "/etc/nixos/secrets/nasys/wireguard/private.key";

      peers = [
        # Legion-5
        {
          publicKey = "dEN7KtZqhkOw9jtmwMu7iDixYthcBZ0HqN+UILqNvFo=";
          allowedIPs = [ "10.11.0.1/32" ];
        }
        # S24U
        {
          publicKey = "yeAuEniGUGZMwGY/vlKYkFV40DF+qcyb2EEcejl62ng=";
          allowedIPs = [ "10.11.0.2/32" ];
        }
        # # Aido laptopas
        # {
        #   publicKey = "";
        #   allowedIPs = [ "10.12.0.1/32" ];
        # }
        # Gundos laptopas
        {
          publicKey = "3nIXAyfpg6eiQ4R37nmFzCer5PNh2XsePgvdHxKBoVw=";
          allowedIPs = [ "10.12.1.1/32" ];
        }
      ];
    };
  };
}

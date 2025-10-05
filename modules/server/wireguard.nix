{pkgs, ...}: {
  networking.nat.enable = true;
  networking.nat.externalInterface = "eth0";
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.10.0.1/16" ];

      listenPort = 51820;

      # postSetup = ''
      #   ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      # '';

      # postShutdown = ''
      #   ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      # '';

     privateKeyFile = "/etc/nixos/secrets/nasys/wireguard/private.key";

      peers = [
        # S24U
        {
          publicKey = "yeAuEniGUGZMwGY/vlKYkFV40DF+qcyb2EEcejl62ng=";
          allowedIPs = [ "10.10.0.2/32" "10.10.0.1/32" ];
        }
      ];
    };
  };
}

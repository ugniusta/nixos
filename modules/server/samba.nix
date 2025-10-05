{...}: {
  users.groups."smbgroup" = {};
  
  users.users."ugnius" = {
    isSystemUser = true;
    group = "smbgroup";
  };
  users.users."gunda" = {
    isSystemUser = true;
    group = "smbgroup";
  };
  users.users."aidas" = {
    isSystemUser = true;
    group = "smbgroup";
  };

  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "Nasys";
        "netbios name" = "Nasys";
        "security" = "user";
        # "use sendfile" = "yes";
        # "max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        "hosts allow" = "10.10.0.0/24 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
        "access based share enum" = "Yes";
      };
      # "public" = {
      #   "path" = "/mnt/Shares/Public";
      #   "browseable" = "yes";
      #   "read only" = "no";
      #   "guest ok" = "yes";
      #   "create mask" = "0644";
      #   "directory mask" = "0755";
      #   "force user" = "username";
      #   "force group" = "groupname";
      # };
      "Private" = {
        "path" = "/mnt/nas/shares/private";
        "read only" = "no";
        # "force group" = "smbgroup";
        "create mask" = "0600";
        "directory mask" = "0700";
        "hide unreadable" = "yes";
        "browsable" = "yes";
      };
      # "Aidas" = {
      #   "path" = "/mnt/nas/aidas";
      #   "read only" = "no";
      #   "create mask" = "0600";
      #   "directory mask" = "0700";
      #   "hide unreadable" = "yes";
      #   "browsable" = "no";
      # };
      # "Gunda" = {
      #   "path" = "/mnt/nas/gunda";
      #   "read only" = "no";
      #   "create mask" = "0600";
      #   "directory mask" = "0700";
      #   "hide unreadable" = "yes";
      #   "browsable" = "no";
      # };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
}

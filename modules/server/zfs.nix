{ pkgs, lib, ...}: {
  
  boot.supportedFilesystems = [
    "zfs"
  ];
  boot.zfs.forceImportRoot = false;
  # boot.zfs.devNodes = "/dev/disk/by-id";
  boot.zfs.extraPools = ["nas"];
  networking.hostId = "ee696dc2";



  systemd.tmpfiles.settings = {
    "nas_mount_dir" = {
      "/mnt/nas" = {
        d = {
          group = "root";
          mode = "0755";
          user = "root";
        };
      };
    };
  };
}

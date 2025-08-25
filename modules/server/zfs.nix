{ pkgs, lib, ...}: {
  
  boot.supportedFilesystems = [
    "zfs"
  ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "ee696dc2";
}

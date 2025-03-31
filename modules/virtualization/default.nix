let gpuIDs = [
  # RTX 3070M
  "10de:24dd" # Video
  "10de:228b"  # Audio
];
in {pkgs, lib, config, ...}: {

  config = let cfg = config.vfio;
  in {
    boot = {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        #"vfio_virqfd"

        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];

      kernelParams = [
        "intel_iommu=on"
        ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs)
      ];
    };


    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = ["ugnius"];
    virtualisation.libvirtd = {
      enable = true;
      qemuOvmf = true;
      qemuSwtpm = true;
    };
    virtualisation.spiceUSBRedirection.enable = true;
    #virtualisation.libvirtd.allowedBridges = ["virbr0"]; # Not sure if this is requiredo

    environment.systemPackages = with pkgs; [
      virtio-win
    ];


  };
}

let
  gpuIDs = [
    # RTX 3070M
    "10de:24dd" # Video
    "10de:228b" # Audio
  ];
in
{ pkgs, lib, config, ... }:
let
  cfg = config.vfio;
in
{
  options.vfio.enable = lib.mkEnableOption "VFIO GPU passthrough boot profile";

  config = {
    boot = {
      extraModulePackages = lib.optionals cfg.enable (
        with config.boot.kernelPackages; [ kvmfr ]
      );

      initrd.kernelModules = lib.optionals cfg.enable [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];

      kernelModules = lib.optionals (!cfg.enable) [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];

      kernelParams = lib.optionals cfg.enable [
        "intel_iommu=on"
        ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs)
      ];

      blacklistedKernelModules = lib.optionals cfg.enable [
        "nouveau"
        "nvidia"
        "nvidia_drm"
        "nvidia_modeset"
        "nvidia_uvm"
      ];

      extraModprobeConfig = ''
        options kvmfr static_size_mb=64
      '';
    };

    systemd.services.kvmfrPermissions = lib.mkIf cfg.enable {
      enable = true;
      wantedBy = ["default.target"];
      wants = ["modprobe@kvmfr.service"];
      script = ''
        chown ugnius:kvm /dev/kvmfr0
        chmod g+rw /dev/kvmfr0
      '';
    };

    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = ["ugnius"];
    virtualisation.libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
      qemu.verbatimConfig = ''
        cgroup_device_acl = [
          "/dev/null", "/dev/full", "/dev/zero",
          "/dev/random", "/dev/urandom",
          "/dev/ptmx", "/dev/kvm",
          "/dev/userfaultfd",
          "/dev/kvmfr0"
        ]
      '';
    };
    virtualisation.spiceUSBRedirection.enable = true;
    virtualisation.libvirtd.allowedBridges = ["virbr0"];

    environment.systemPackages = with pkgs; [
      guestfs-tools
      virtiofsd

      virtio-win
    ] ++ lib.optionals cfg.enable (with pkgs; [
      looking-glass-client
      linuxKernel.packages.linux_6_12.kvmfr
    ]);

    fileSystems."/mnt/Win11VM" = {
      device = "/dev/disk/by-uuid/a09b771f-8f8c-487f-922f-2bf85a95374e";
      fsType = "ext4";
    };
  };
}

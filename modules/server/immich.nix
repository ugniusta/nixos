{ pkgs, inputs, ... }:
let
  immichPort = 2283;

  mkUserContainer = user: {
    user = user;
    autoStart = true;
    image = "";

    environment = [
      "/mnt/nas/shares/private/${user}/S24U"
    ];
  };
in
{
  services.immich.enable = true;
  services.immich = {
    port = immichPort;
    host = "0.0.0.0";
    accelerationDevices = null;
    machine-learning.enable = true;
  };

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];

  networking.firewall.extraInputRules = ''
    ip saddr { 10.11.0.0/16, 10.12.0.0/16 } tcp dport ${toString immichPort} accept
  '';

  # nixpkgs.config.cudaSupport = true;
  # nixpkgs.config = {
  #   pythonPackages = pkgs.python312Packages;
  # };

  # hardware.nvidia-container-toolkit.enable = true; # Does not allow immich to transcode.

  nixpkgs.overlays = [
    (final: prev: {
      onnxruntime = prev.onnxruntime.override { cudaSupport = true; };
      immich = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.immich;
      immich-machine-learning = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.immich-machine-learning;
    })
  ];

  # services.immich.machine-learning = {
  #   environment.LD_LIBRARY_PATH = "${pkgs.python313Packages.onnxruntime}/lib/python3.13/site-packages/onnxruntime/capi";
  # };

  virtualisation.oci-containers.backend = "podman";
}

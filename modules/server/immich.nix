{
  pkgs,
  inputs,
  ...
}:
let
  immichPort = 2283;
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;

    # overlays = [
    # (_: prev: {
    #   onnxruntime = prev.onnxruntime.override {
    #     cudaPackages = prev.cudaPackages_12_8;
    #     cudaSupport = true;
    #   };
    # })
  # ];

  };

  # mkUserContainer = user: {
  #   user = user;
  #   autoStart = true;
  #   image = "";

  #   environment = [
  #     "/mnt/nas/shares/private/${user}/S24U"
  #   ];
  # };
in
{
  services.immich.enable = true;
  services.immich = {
    package = pkgs-unstable.immich;
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

  virtualisation.oci-containers.backend = "podman";
}

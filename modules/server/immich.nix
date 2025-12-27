{ ... }:
{
  services.immich.enable = true;
  services.immich.port = 2283;

  services.immich.accelerationDevices = null;

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];

}

{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mqttui
    bacon
  ];
}

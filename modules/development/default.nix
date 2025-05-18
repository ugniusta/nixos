{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mqttui
    bacon
    fx
  ];

  hardware.saleae-logic.enable = true;
}

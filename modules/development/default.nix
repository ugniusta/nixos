{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mqttui
    bacon
    fx
    rust-analyzer
    nixd
  ];

  hardware.saleae-logic.enable = true;
}

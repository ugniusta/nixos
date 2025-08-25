{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mqttui
    bacon
    fx
    rust-analyzer
    nixd
    rustup
  ];

  hardware.saleae-logic.enable = true;
}

{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mqttui
    bacon
    fx
    rust-analyzer
    rustup
  ];

  hardware.saleae-logic.enable = true;
}

{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mqttui
    bacon
    fx
    rust-analyzer
    nixd
    nixfmt
  ];

  hardware.saleae-logic.enable = true;
}

{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mqttui
    bacon
    fx
    rust-analyzer
    nixd
    nixfmt
    uv
  ];

  hardware.saleae-logic.enable = true;
}

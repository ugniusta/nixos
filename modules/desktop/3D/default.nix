{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    f3d
    prusa-slicer
  ];
}

let
  username = "linas";
in
{
  config,
  flakeDir,
  pkgs,
  ...
}:
{

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  imports = [
    ./hardware-configuration.nix
    "${flakeDir}/modules/core"
    "${flakeDir}/modules/desktop/gaming"
  ];

  networking.hostName = "Linas";
  networking.networkmanager.enable = true;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  users.users."${username}" = {
    isNormalUser = true;
    description = "Linas Stašaitis";
    extraGroups = [ "networkmanager" ];
    packages = with pkgs; [
      lutris
      heroic
      libreoffice-qt-fresh
      vlc
    ];
  };

  users.users.admin = {
    openssh.authorizedKeys.keyFiles = [
      "/etc/nixos/secrets/${username}/ssh/legion-5_admin@Linas.pub"
      "/etc/nixos/secrets/${username}/ssh/s24u_admin@Linas.pub"
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # TODO: move out
  # Wireguard network-manager
  networking.firewall = {
    # if packets are still dropped, they will show up in dmesg
    logReversePathDrops = true;
    # wireguard trips rpfilter up
    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
    '';
  };

  # boot.kernelParams = [ "radeon.cik_support=0" "radeon.si_support=0" "amdgpu.cik_support=1" "amdgpu.si_support=1" ];
  # boot.kernelParams = [ "radeon.si_support=0" "amdgpu.si_support=1" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [
    "radeon.cik_support=0"
    "radeon.si_support=0"
    "amdgpu.cik_support=1"
    "amdgpu.si_support=1"
  ];

  # hardware.graphics.extraPackages = with pkgs; [ amdvlk ];
  # hardware.graphics.extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];

  services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.firefox.enable = true;

  services.xserver.enable = false;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.nix-ld.enable = true;

}

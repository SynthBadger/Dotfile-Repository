{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb.layout = "us";
  services.flatpak.enable = true;
  services.hardware.openrgb.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };



    services.printing.enable = true;

  hardware.keyboard.qmk.enable = true;
  services.udev.packages = with pkgs; [via];
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  hardware.bluetooth.enable = true;

  users.users.imogen = {
    isNormalUser = true;
    description = "imogen";
    shell = "/run/current-system/sw/bin/zsh";  # <-- use system path, not pkgs.zsh
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    packages = with pkgs; [ kdePackages.kate ];
  };

  programs.gamemode.enable = true;
  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.niri.enable = false;


  # Install Noctalia shell (no services.* option, just a package)
  environment.systemPackages = with pkgs; [
    git
    dxvk
    vesktop
    protonplus
    wine
    winetricks
    telegram-desktop
    mangohud
    fastfetch
    openrgb-with-all-plugins
    goverlay
    home-manager
    zsh
    niri
    neovim
    via
    qmk
    jxrlib

    # … add other packages you want
    (pkgs.xivlauncher-rb.override {
      useGameMode = true;
      useSteamRun = true;
      nvngxPath = "${config.hardware.nvidia.package}/lib/nvidia/wine";
    })
  ];

  environment.shells = with pkgs; [
    zsh
  ];

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  system.stateVersion = "25.05";
}

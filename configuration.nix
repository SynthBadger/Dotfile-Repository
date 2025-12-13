{ config, lib, pkgs, ... }:

{

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  nix.settings.auto-optimise-store = true;

  imports = [ 
	./hardware-configuration.nix 
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.displayManager.sddm =
    {
      enable = true;
      wayland.enable = true;
    };
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



  #services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
    cups-filters
    cups-browsed
  ];
};

 # Nvidia and Keybord settings
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
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "lp"];
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
    dxvk
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
    imagemagick
    #printer stuff
    brlaser
    #SSH
    putty
    cups

    #KDE Setup

    #kdePackages.discover # Optional: Install if you use Flatpak or fwupd firmware update sevice
    kdePackages.kcalc # Calculator
    kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
    kdePackages.kclock # Clock app
    #kdePackages.kcolorchooser # A small utility to select a color
    #kdePackages.kolourpaint # Easy-to-use paint program
    #kdePackages.ksystemlog # KDE SystemLog Application
    kdePackages.sddm-kcm # Configuration module for SDDM
    #kdiff3 # Compares and merges 2 or 3 files or directories
    kdePackages.isoimagewriter # Optional: Program to write hybrid ISO files onto USB disks
    kdePackages.partitionmanager # Optional: Manage the disk devices, partitions and file systems on your computer
    # Non-KDE graphical packages
    hardinfo2 # System information and benchmarks for Linux systems
    #vlc # Cross-platform media player and streaming server
    wayland-utils # Wayland utilities
    #wl-clipboard # Command-line copy/paste utilities for Wayland

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

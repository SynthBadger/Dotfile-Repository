{ config, pkgs, lib, ... }:

{
  # -------------------------------
  # User info
  # -------------------------------
  home.username = "imogen";
  home.homeDirectory = "/home/imogen";
  home.stateVersion = "25.11";

  # -------------------------------
  # Packages
  # -------------------------------
  home.packages = [
    pkgs.vim
    pkgs.openrgb
    pkgs.neovim
    # add more packages here
  ];

  # -------------------------------
  # Autostart OpenRGB via XDG .desktop file
  # -------------------------------
  home.file.".config/autostart/openrgb.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=OpenRGB
    Exec=${pkgs.openrgb}/bin/OpenRGB --minimized --startminimized --nogui
    X-GNOME-Autostart-enabled=true
  '';

  # -------------------------------
  # Udev rules for RGB device access
  # -------------------------------
  home.file.".config/udev/rules.d/60-openrgb.rules".text = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="1b1c", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="1209", MODE="0666"
  '';

  # -------------------------------
  # Dotfiles management
  # -------------------------------
  home.file = {
    # Example: ".screenrc".source = dotfiles/screenrc;
  };

  # -------------------------------
  # Session variables
  # -------------------------------
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # -------------------------------
  # Home Manager itself
  # -------------------------------
  programs.home-manager.enable = true;
}

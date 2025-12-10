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
    pkgs.vlc
    
    # add more packages here
  ];

  # -------------------------------
  # Dotfiles and custom files
  # -------------------------------
  home.file = {
    ".config/autostart/openrgb.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=OpenRGB
      Exec=${pkgs.openrgb}/bin/OpenRGB --minimized --startminimized --nogui
      X-GNOME-Autostart-enabled=true
    '';

    ".config/udev/rules.d/60-openrgb.rules".text = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="1b1c", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="1209", MODE="0666"
    '';
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

  # -------------------------------
  # Zsh configuration
  # -------------------------------
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      PROMPT='%/ %#'
    '';
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
      home = "cd ~/.dotfiles";
      garbage = "nix-collect-garbage -d;";
      hmrefresh = "home-manager switch --flake .";
      takeoutdatrash = "nix-channel --update; nix-env -u always; nix-collect-garbage -d; rm /nix/var/nix/gcroots/auto*;";
      upgrade = "sudo nixos-rebuild switch --upgrade";
    };
    history.size = 10000;
  };

}

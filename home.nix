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
    pkgs.swaybg
    pkgs.xwayland-satellite 
    pkgs.polkit_gnome
    pkgs.swayidle

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

    # Example dotfile management
    # ".screenrc".source = ./dotfiles/screenrc;
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
    initExtra = ''
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


 #---------------------------------
 # Niri Setup Maybe?
 #---------------------------------
   
  # Provide Niri's config file via Home Manager
  xdg.configFile."niri/config.kdl".source = ./niri/default-config.kdl;



  # Supporting programs (needed for default keybindings)
  programs.alacritty.enable = true;   # terminal (Super+T)
  programs.fuzzel.enable = true;      # app launcher (Super+D)
  programs.swaylock.enable = true;    # screen locker (Super+Alt+L)
  programs.waybar.enable = true;      # status bar

  # Services that complement Niri
  services.mako.enable = true;        # notifications
  services.swayidle.enable = true;    # idle management
  services.polkit-gnome.enable = true;# polkit agent

  
 
}






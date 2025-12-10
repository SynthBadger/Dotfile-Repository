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
    pkgs.zed

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

  #-------------------------------
  # Zed Config Maybe
  #-------------------------------

  programs.zed-editor = {
  enable = true;

  # This populates the userSettings "auto_install_extensions"
  extensions = [ "nix" "toml" "elixir" "make" ];

  # Everything inside of these brackets are Zed options
  userSettings = {
    assistant = {
      enabled = true;
      version = "2";
      default_open_ai_model = null;

      # Provider options:
      # - zed.dev models (claude-3-5-sonnet-latest) requires GitHub connected
      # - anthropic models (claude-3-5-sonnet-latest, claude-3-haiku-latest, claude-3-opus-latest) requires API_KEY
      # - copilot_chat models (gpt-4o, gpt-4, gpt-3.5-turbo, o1-preview) requires GitHub connected
      default_model = {
        provider = "zed.dev";
        model = "claude-3-5-sonnet-latest";
      };

      # inline_alternatives = [
      #   {
      #     provider = "copilot_chat";
      #     model = "gpt-3.5-turbo";
      #   }
      # ];
    };

    node = {
      path = lib.getExe pkgs.nodejs;
      npm_path = lib.getExe' pkgs.nodejs "npm";
    };

    hour_format = "hour24";
    auto_update = false;

    terminal = {
      alternate_scroll = "off";
      blinking = "off";
      copy_on_select = false;
      dock = "bottom";
      detect_venv = {
        on = {
          directories = [ ".env" "env" ".venv" "venv" ];
          activate_script = "default";
        };
      };
      env = {
        TERM = "alacritty";
      };
      font_family = "FiraCode Nerd Font";
      font_features = null;
      font_size = null;
      line_height = "comfortable";
      option_as_meta = false;
      button = false;
      shell = "system";
      # shell = {
      #   program = "zsh";
      # };
      toolbar = {
        title = true;
      };
      working_directory = "current_project_directory";
    };

    lsp = {
      rust-analyzer = {
        binary = {
          # path = lib.getExe pkgs.rust-analyzer;
          path_lookup = true;
        };
      };

      nix = {
        binary = {
          path_lookup = true;
        };
      };

      elixir-ls = {
        binary = {
          path_lookup = true;
        };
        settings = {
          dialyzerEnabled = true;
        };
      };
    };

    languages = {
      "Elixir" = {
        language_servers = [ "!lexical" "elixir-ls" "!next-ls" ];
        format_on_save = {
          external = {
            command = "mix";
            arguments = [ "format" "--stdin-filename" "{buffer_path}" "-" ];
          };
        };
      };

      "HEEX" = {
        language_servers = [ "!lexical" "elixir-ls" "!next-ls" ];
        format_on_save = {
          external = {
            command = "mix";
            arguments = [ "format" "--stdin-filename" "{buffer_path}" "-" ];
          };
        };
      };
    };

    vim_mode = true;

    # Tell Zed to use direnv and direnv can use a flake.nix environment
    load_direnv = "shell_hook";
    base_keymap = "VSCode";

    theme = {
      mode = "system";
      light = "One Light";
      dark = "One Dark";
    };

    show_whitespaces = "all";
    ui_font_size = 16;
    buffer_font_size = 16;
  };
};


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

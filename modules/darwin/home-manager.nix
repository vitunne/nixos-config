{ config, pkgs, lib, home-manager, ... }:

let
  user = "victor.suzdalev";
  email = "victor.suzdalev@aliexpress.ru"; in
{
  # imports = [
  #  ./dock
  # ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    brews = pkgs.callPackage ./brews.nix {};
    casks = pkgs.callPackage ./casks.nix {};
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
    # you may receive an error message "Redownload Unavailable with This Apple ID".
    # This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)
    masApps = {
      "AmneziaWG" = 6478942365;
      "Magnet" = 441258766;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home = {
        packages = pkgs.callPackage ./packages.nix {};
        enableNixpkgsReleaseCheck = false;
        stateVersion = "24.11";
      };
      programs = {
        wezterm = {
          enable = true;
          extraConfig = ''
            local wezterm = require 'wezterm'
            local config = wezterm.config_builder()
            config.color_scheme = 'AdventureTime'
            config.font = wezterm.font 'PragmataProMono Nerd Font Mono'
            config.font_size = 20

            return config
          '';
        };
      } // import ../shared/home-manager.nix { inherit config pkgs lib; };
    };
  };

  # Fully declarative dock using the latest from Nix Store
  # local.dock.enable = true;
  # local.dock.entries = [
  #   { path = "/Applications/Slack.app/"; }
  #   { path = "/System/Applications/Messages.app/"; }
  #   { path = "/System/Applications/Facetime.app/"; }
  #   { path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }
  #   { path = "/System/Applications/Music.app/"; }
  #   { path = "/System/Applications/News.app/"; }
  #   { path = "/System/Applications/Photos.app/"; }
  #   { path = "/System/Applications/Photo Booth.app/"; }
  #   { path = "/System/Applications/TV.app/"; }
  #   { path = "/System/Applications/Home.app/"; }
  #   {
  #     path = toString myEmacsLauncher;
  #     section = "others";
  #   }
  #   {
  #     path = "${config.users.users.${user}.home}/.local/share/";
  #     section = "others";
  #     options = "--sort name --view grid --display folder";
  #   }
  #   {
  #     path = "${config.users.users.${user}.home}/.local/share/downloads";
  #     section = "others";
  #     options = "--sort name --view grid --display stack";
  #   }
  # ];

}

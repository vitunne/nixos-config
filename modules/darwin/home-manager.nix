{ config, pkgs, lib, home-manager, ... }:

let
  user = "victor.suzdalev";
  email = "victor.suzdalev@aliexpress.ru"; in
{
  imports = [
   ./dock
  ];

  # It me
  system.primaryUser = "${user}";

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
    greedyCasks = true;
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
      # "AmneziaWG" = 6478942365;
      "Magnet" = 441258766;
      "Mattermost Desktop" = 1614666244;
      "Happ" = 6746188973;
    };
  };

  # `brew bundle` (used by the homebrew module) only installs missing mas apps,
  # it never upgrades them, so upgrade them explicitly on each rebuild.
  system.activationScripts.postActivation.text = ''
    echo "Upgrading Mac App Store apps..." >&2
    sudo -u ${user} ${pkgs.mas}/bin/mas upgrade || true
  '';

  # Enable home-manager
  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home = {
        packages = pkgs.callPackage ./packages.nix {};
        enableNixpkgsReleaseCheck = false;
        stateVersion = "24.11";
        sessionPath = [
          "/opt/homebrew/bin"
          "/opt/homebrew/sbin"
          "/Users/${user}/vk-cloud-solutions/bin"
        ];
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
  local.dock = {
    enable   = true;
    username = user;
    entries = [
      { path = "/Applications/Apps.app"; }
      { path = "/Applications/Google Chrome.app"; }
      { path = "${pkgs.wezterm}/Applications/WezTerm.app"; }
      { path = "/Applications/Freelens.app"; }
      { path = "/Applications/Visual Studio Code.app"; }
      { path = "/Applications/Mattermost.app"; }
      { path = "/Applications/Obsidian.app"; }
      { path = "/Applications/Telegram.app"; }
      { path = "/Applications/Spotify.app"; }
      { path = "/System/Applications/Calendar.app"; }
      { path = "/System/Applications/System Settings.app"; }
      { path = "/Applications/Happ.app"; }
      {
        path = "${config.users.users.${user}.home}/Downloads";
        section = "others";
        options = "--sort name --view grid --display stack";
      }
    ];
  };

}

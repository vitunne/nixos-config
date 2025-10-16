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
    onActivation.autoUpdate = false;
    onActivation.upgrade = false;

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
      "Mattermost Desktop" = 1614666244;
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
        sessionPath = [
          "/Users/${user}/vk-cloud-solutions/bin"
        ];
      };
      programs = {
        kitty = {
          enable = true;
          font = {
            name = "PragmataProMono Nerd Font Mono";
            size = 24;
          };
          themeFile = "AdventureTime";
        };
      } // import ../shared/home-manager.nix { inherit config pkgs lib; };
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local.dock = {
    enable   = true;
    username = user;
    entries = [
      { path = "/Applications/Google Chrome.app"; }
      { path = "/Applications/Visual Studio Code.app"; }
      { path = "/Applications/Cursor.app"; }
      { path = "${pkgs.kitty}/Applications/kitty.app"; }
      { path = "/Applications/Mattermost.app"; }
      { path = "/Applications/Telegram.app"; }
      { path = "/Applications/Spotify.app"; }
      { path = "/System/Applications/Calendar.app"; }
      { path = "/System/Applications/System Settings.app"; }
      {
        path = "${config.users.users.${user}.home}/.local/share/downloads";
        section = "others";
        options = "--sort name --view grid --display stack";
      }
    ];
  };

}

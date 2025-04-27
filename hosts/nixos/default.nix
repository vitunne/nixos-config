# { config, lib, pkgs, ... }:

# {
#   imports = [
#     # ../../modules/nixos/home-manager.nix
#     # ../../modules/shared
#   ];

#   wsl.enable = true;
#   wsl.defaultUser = "nixos";

#   # This value determines the NixOS release from which the default
#   # settings for stateful data, like file locations and database versions
#   # on your system were taken. It's perfectly fine and recommended to leave
#   # this value at the release version of the first install of this system.
#   # Before changing this value read the documentation for this option
#   # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
#   system.stateVersion = "24.11"; # Did you read the comment?

#   nix.extraOptions = ''
#     experimental-features = nix-command flakes
#   '';

#   programs.nix-ld = {
#     enable = true;
#   };

#   environment.systemPackages = with pkgs; [
#     neovim
#   ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

#   # users.users.vitune = {
#   #   isNormalUser = true;
#   #   group = "vitune";
#   #   extraGroups = [ "wheel" ]; # Enable sudo for the user
#   # };

#   # users.groups.vitune = {};
# }

{ config, inputs, lib, pkgs, agenix, ... }:

let user = "nixos";
    keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9GrdiCkoU8UiGgLU6M6/VFRSpPnGHdBrtK0O9MhnmH" ]; in
{
  imports = [
    ../../modules/nixos/home-manager.nix
    ../../modules/shared
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  # Turn on flag for proprietary software
  nix = {
    nixPath = [ "nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos" ];
    settings = {
      allowed-users = [ "${user}" ];
      trusted-users = [ "@admin" "${user}" ];
      substituters = [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };

  # Manages keys and such
  programs = {
    # My shell
    zsh.enable = true;
    
    # vscode support
    nix-ld.enable = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
  ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

  # Sync state between machines
  # Add docker daemon
  # virtualisation = {
  #   docker = {
  #     enable = true;
  #     logDriver = "json-file";
  #   };
  # };

  # It's me, it's you, it's everyone
  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "docker"
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = keys;
    };

    root = {
      openssh.authorizedKeys.keys = keys;
    };
  };

  # Don't require password for users in `wheel` group for these commands
  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
       {
         command = "${pkgs.systemd}/bin/reboot";
         options = [ "NOPASSWD" ];
        }
      ];
      groups = [ "wheel" ];
    }];
  };

  system.stateVersion = "24.11"; # Don't change this
}

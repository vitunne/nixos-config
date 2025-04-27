{ config, inputs, lib, pkgs, agenix, ... }:

let user = "nixos";
    keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9GrdiCkoU8UiGgLU6M6/VFRSpPnGHdBrtK0O9MhnmH" ]; in
{
  imports = [
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

  # Add docker daemon
  virtualisation = {
    docker = {
      enable = true;
      logDriver = "json-file";
    };
  };

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

  system.stateVersion = "24.11"; # Don't change this

}

{ config, pkgs, lib, ... }:

let
  user = "nixos";
  shared-programs = import ../shared/home-manager.nix { inherit config pkgs lib; };
in
{
  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix {};
    stateVersion = "24.11";
  };

  programs = shared-programs;

}

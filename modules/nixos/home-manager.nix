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

  # This installs my GPG signing keys for Github
  # systemd.user.services.gpg-import-keys = {
  #   Unit = {
  #     Description = "Import gpg keys";
  #     After = [ "gpg-agent.socket" ];
  #   };

  #   Service = {
  #     Type = "oneshot";
  #     ExecStart = toString (pkgs.writeScript "gpg-import-keys" ''
  #       #! ${pkgs.runtimeShell} -el
  #       ${lib.optionalString (gpgKeys!= []) ''
  #       ${pkgs.gnupg}/bin/gpg --import ${lib.concatStringsSep " " gpgKeys}
  #       ''}
  #     '');
  #   };

  #   Install = { WantedBy = [ "default.target" ]; };
  # };

}

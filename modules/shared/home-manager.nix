{ config, pkgs, lib, ... }:

let user = "victor.suzdalev"; in
{
  zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
    };
    shellAliases = {
      v = "nvim";
      k = "kubectl";
      h = "helm";
    };
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  direnv = {
    enable = true;
  };
}

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
    plugins = [
      {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./config;
          file = "p10k.zsh";
      }
    ];
  };

  fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  
  direnv = {
    enable = true;
  };
}

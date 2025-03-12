{ config, pkgs, lib, ... }:

let name = "Viktor Suzdalev";
    user = "victor.suzdalev";
    email = "victor.suzdalev@aliexpress.ru"; in
{
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

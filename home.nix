{ config, pkgs, lib, ... }:

{
  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  # Home Manager configurations for the user
  home.username = "nik";
  home.homeDirectory = lib.mkForce "/home/nik";
  home.stateVersion = "23.11";

  # Git configuration with directory-specific settings
  programs.git = {
    enable = true;

    extraConfig = {
      # Per-directory configuration using includeIf
      "includeIf.gitdir:/home/nik/Repos/nikslp/" = {
        path = "/home/nik/.gitconfig-nkslip";
      };

      "includeIf.gitdir:/home/nik/Repos/woodenikki/" = {
        path = "/home/nik/.gitconfig-personal";
      };
    };
  };

  # Applications and tools to be installed
  home.packages = with pkgs; [
    brave
    firefox
    spotify
    discord
    kitty
  ];

  # Zsh configuration with custom aliases
  programs.zsh = {
    enable = true;
    initExtra = ''
      export PATH=$PATH:/custom/path
      alias gs='git status'
      alias ll='ls -alF'
    '';
  };
}

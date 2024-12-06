{
  config, pkgs, lib, ... }:

{
  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  # Rest of your Home Manager configuration
  home.username = "nik";
  home.homeDirectory = lib.mkForce "/home/nik";
  home.stateVersion = "23.11";

  programs.git = {
    enable = true;

    # Remove global defaults and focus on directory-specific configurations
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

  home.packages = with pkgs; [
    brave
    firefox
    spotify
    discord
    kitty
  ];
}

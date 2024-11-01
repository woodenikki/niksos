# home.nix

{ config, pkgs, ... }:

{
  home.username = "nik";
  home.stateVersion = "23.11";
  home.homeDirectory = "/home/nik";

  programs.zsh.enable = true;

  home.packages = [
    pkgs.zsh
    pkgs.vim
    pkgs.git
  ];

  # Define any other configuration options you had in your previous file
  # For example, shell aliases, environment variables, etc.

  programs.git = {
    enable    = true;
    userName  = "nkslip";
    userEmail = "nikslatestproject@gmail.com";
  };
}


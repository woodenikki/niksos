{ config, pkgs, lib, ... }:

{
  # Set user information
  home.username = "nik";
  home.homeDirectory = lib.mkForce "/home/nik";  # Force to avoid conflicts
  home.stateVersion = "23.11";

  # Current Version Missmatch (idgaf)
  home.enableNixpkgsReleaseCheck = false;


  # Enable Zsh and specify packages
  programs.zsh.enable = true;
  home.packages = with pkgs; [
    brave
    firefox
    spotify
    discord
    kitty # similar to iterm2?
  ];

  # Git configuration for the user
  programs.git = {
    enable = true;
    userName = "woodenikki";
    userEmail = "woodenikki@gmail.com";
  };

}

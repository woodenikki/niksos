#!/usr/bin/env bash

# Script to update NixOS system, channels, flakes, and Home Manager

set -e  # Exit on any error

echo "Starting NixOS update process..."

# Function to update Nix channels
update_channels() {
  echo "Updating Nix channels..."
  sudo nix-channel --update
}

# Function to update flake inputs (only if using flakes)
update_flakes() {
  if [ -d /etc/nixos ]; then
    if [ -f /etc/nixos/flake.nix ]; then
      echo "Updating flake inputs for system..."
      sudo nix flake update /etc/nixos
    else
      echo "No flake.nix found in /etc/nixos; skipping flake update."
    fi
  else
    echo "/etc/nixos directory does not exist; skipping flake update."
  fi
}

# Function to rebuild the system
rebuild_system() {
  echo "Rebuilding NixOS system..."
  if [ -f /etc/nixos/flake.nix ]; then
    sudo nixos-rebuild switch --flake /etc/nixos
  else
    sudo nixos-rebuild switch
  fi
}

# Function to update Home Manager (if applicable)
update_home_manager() {
  if command -v home-manager &>/dev/null; then
    echo "Updating Home Manager..."
    if [ -f ~/.config/home-manager/flake.nix ]; then
      nix flake update ~/.config/home-manager
      home-manager switch --flake ~/.config/home-manager
    else
      home-manager switch
    fi
  else
    echo "Home Manager is not installed; skipping Home Manager update."
  fi
}

# Main update sequence
update_channels
update_flakes
rebuild_system
update_home_manager

echo "NixOS update process complete!"


{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking configuration
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Enable NetworkManager

  # Time zone configuration
  time.timeZone = "America/Denver";

  # Localization settings
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # X11 and GNOME Desktop Environment
  services.xserver = {
    enable = true; # Enable the X11 windowing system.
    layout = "us"; # Set keyboard layout
    xkbVariant = ""; # Set keyboard variant
    displayManager.gdm.enable = true; # Enable GDM
    desktopManager.gnome.enable = true; # Enable GNOME Desktop Environment

    # Touchpad and gesture support
    libinput.enable = true; # Enable libinput for input devices
    libinput = {
      touchpad = {
        enable = true; # Enable touchpad
        tapToClick = true; # Enable tap-to-click
        naturalScrolling = true; # Enable natural scrolling
        middleEmulation = true; # Enable middle-click emulation
      };
    };
  };

  # Printing support
  services.printing.enable = true; # Enable CUPS for printing

  # Sound configuration
  sound.enable = true;
  hardware.pulseaudio.enable = false; # Use PipeWire instead of PulseAudio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User configuration
  users.users.nik = {
    isNormalUser = true;
    description = "Nik";
    group = "nik"; # Set the primary group
    extraGroups = [ "networkmanager" "wheel" ]; # Additional group memberships
    home = "/home/nik";
    shell = pkgs.zsh; # Use Zsh as the default shell
    ignoreShellProgramCheck = true; # Prevent shell-related conflicts
  };

  # Group configuration
  users.groups.nik = {}; # Define group `nik`

  # Enable automatic login for the user
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "nik";

  # GNOME autologin workaround
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System-wide packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    zsh
    oh-my-zsh
    python310
    vscode
    bat
    (vim_configurable.overrideAttrs (oldAttrs: {
      withX = true;
      withGtk = true;
    }))

    # Gesture improvements (if available)
    # Use nixpkgs-unstable for this package if required
    # (nixpkgs-unstable.gnome-shell-extension-gesture-improvements)
  ];

  # Flake configuration
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # Match the state version to your NixOS installation
  system.stateVersion = "23.11";
}

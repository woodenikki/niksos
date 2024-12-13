{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Timezone
  time.timeZone = "America/Denver";

  # Localization
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

  # X11 and GNOME
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    libinput.enable = true;
  };

  # Custom touchpad configuration (using lib.mkForce or renaming)
  environment.etc."X11/xorg.conf.d/40-libinput.conf".text = lib.mkForce ''
    Section "InputClass"
        Identifier "libinput touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"

        Option "Tapping" "on"              # Enable tap-to-click
        Option "NaturalScrolling" "true"   # Enable natural scrolling
        Option "MiddleEmulation" "true"    # Enable middle-click emulation
    EndSection
  '';

  # Printing
  services.printing.enable = true;

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Users
  users.users.nik = {
    isNormalUser = true;
    description = "Nik";
    group = "nik";
    extraGroups = [ "networkmanager" "wheel" ];
    home = "/home/nik";
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  # Groups
  users.groups.nik = {};

  # Autologin
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "nik";

  # GNOME autologin workaround
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # System Packages
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
  ];

  # Flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # Match system version
  system.stateVersion = "23.11";
}

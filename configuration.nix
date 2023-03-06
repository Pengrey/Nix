# NixOs configuration file

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_PT.UTF-8";
    LC_IDENTIFICATION = "pt_PT.UTF-8";
    LC_MEASUREMENT = "pt_PT.UTF-8";
    LC_MONETARY = "pt_PT.UTF-8";
    LC_NAME = "pt_PT.UTF-8";
    LC_NUMERIC = "pt_PT.UTF-8";
    LC_PAPER = "pt_PT.UTF-8";
    LC_TELEPHONE = "pt_PT.UTF-8";
    LC_TIME = "pt_PT.UTF-8";
  };

  # Enable the Wayland windowing system
  services.xserver = {
    enable = true;

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Setup Keyboard Layout
    layout = "pt";
    xkbOptions = "no_dead_keys";
  };

  # Exclude some gnome applications from default install
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese	# webcam tool
    gnome-music
    gnome-terminal
    gedit	# text editor
    epiphany	# web browser
    geary	# email reader
    evince	# document viewer
    gnome-characters
    totem	# video player
    tali	# poker game
    iagno	# go game
    hitori	# sodoku game
    atomix	# puzzle game
    yelp	# Help view
    gnome-contacts
    gnome-initial-setup
  ]);
 
  # Running gnome programs outside of gnome
  programs.dconf.enable = true;
  
  # Configure console keymap
  console.keyMap = "pt-latin1";

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  
  # Define the the shell to be used by the users
  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pengrey = {
    isNormalUser = true;
    description = "pengrey";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox		# Internet browser
      #nerdfonts	# Fonts with icons used by the system
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # System commands
    exa			# ls replacement
    wget		# File retriever
    btop		# Rsource Monitor
    bat			# cat replacement
    neofetch		# Shows system information

    # Window Manager Stuff
    alacritty		# GPU Accelerated Terminal Emulator
    ranger		# Terminal file manager
    gnome.gnome-tweaks	# Tweaks for gnome
  ];
  
  # NeoVim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;	# Set nvim as tyhe default editor using EDITOR env var
    vimAlias = true; 		# Symlink vim to nvim
  };

  # ZSH Configuration with ohMysZsh
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      vim = "nvim";
      ls = "exa -l";
      cat = "bat";
      update = "sudo nixos-rebuild switch";
    };
    ohMyZsh = {
      enable = true;
      theme = "gozilla";
    };
  };

  # Tmux Configuration
  programs.tmux = {
    enable = true;
    extraConfig = ''
      # Use Mouse Support
      set-option -g mouse on
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = "22.14.1";

}

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

  # Enable i3
  services.xserver = {
    enable = true;

    # Setup Keyboard Layout
    layout = "pt";
    xkbOptions = "nodeadkeys";

    # i3 stuff
    desktopManager.xterm.enable = false;
   
    displayManager.defaultSession = "none+i3";

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
  };
  
  # Set fonts
  fonts.fonts = with pkgs; [ roboto ];

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
      arandr		# xrandr gui
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # System commands
    exa			    # ls replacement
    wget		    # File retriever
    btop		    # Rsource Monitor
    bat			    # cat replacement
    neofetch		    # Shows system information

    # Window Manager Stuff
    alacritty		        # GPU Accelerated Terminal Emulator
    lf				# Terminal file maneger writen in go
  ];
 
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # NeoVim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;	# Set nvim as the default editor using EDITOR env var
    vimAlias = true; 		  # Symlink vim to nvim
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
  system.stateVersion = "22.11";

}

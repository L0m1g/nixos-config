{ config, pkgs, lib, desktop, ... }:

{
  imports = [
    ./raid.nix
    ./bepovim.nix
    ../../wm/bspwm.nix
    ../../apps/qemu.nix
  ];
  nix.settings.experimental-features = ["nix-command" "flakes" ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [ "amdgpu" "kvm-amd" ];
  boot.extraModulePackages = [];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ 
  	"mem_sleep_default=deep" 
	"amdgpu.si_support=0"
	  "amdgpu.cik_support=0"
	  "radeon.si_support=0"
	  "radeon.cik_support=0"
  ];

  fileSystems."/" = {
  device = "/dev/disk/by-uuid/b4e3577b-17ab-4a89-9aeb-4e223be4c75b"; # à adapter si tu as un autre label/disque
  fsType = "ext4"; # ou btrfs, xfs, ce que t'as utilisé
};
  swapDevices = [] ;
  
  boot.plymouth.enable = true ;
  boot.loader.timeout = 5;
  boot.loader.systemd-boot.enable = true ;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  boot.tmp.cleanOnBoot = true ;
  systemd.coredump.enable = false ;
  services.journald.extraConfig = ''
	SystemMaxUse=200M
	RuntimeMaxUse=100M
  '';

  hardware.firmware = with pkgs ; [ linux-firmware ];
  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
  	enable = true ;
  	extraPackages = with pkgs ; [
	    mesa libva libva-utils libvdpau libva-vdpau-driver vaapiVdpau libvdpau-va-gl amdvlk vulkan-tools vulkan-loader vulkan-validation-layers
	  ];
	enable32Bit = true ;
  };
  environment.variables = {
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "va_gl";
  };

  hardware.bluetooth.enable = true ;
  environment.etc."pam.d/i3lock".text = ''
       auth     include login
       account  include login
       password include login
       session  include login
       '';
  services.blueman.enable = true ;

  services.xserver.enable = true ;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.logind.extraConfig = ''
	IdleAction=suspend
	IdleActionSec=5min
	HandleLidSwitch=suspend
	HandleLidSwitchDocked=ignore
	'';

  networking.hostName = "pennsardin";
  time.timeZone = "Europe/Paris";
  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  services.printing.enable = true ;
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  environment.systemPackages = with pkgs; [
#  i3lock
    btrfs-progs
    evtest
    gdu
    git
    glances
    lm_sensors
    neovim
    snapper
    tmux
    xorg.xev
    xorg.xkbcomp
  ];

  programs.steam.enable = true ;
  hardware.xpadneo.enable = true ;
  programs.zsh.enable = true;
  users.users.lomig = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "lp" "wheel" ];
    shell = pkgs.zsh;
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnsupportedSystem = true ;
  };
  system.stateVersion = "25.05"; # pour éviter les hurlements inutiles
}


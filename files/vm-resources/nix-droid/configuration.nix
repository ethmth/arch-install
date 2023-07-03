# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.05";
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
      <nixpkgs/nixos/modules/virtualisation/qemu-guest-agent.nix>
    ];

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nix-droid"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = false;
  services.xserver.displayManager.startx.enable = true;
  #services.xserver.desktopManager.gnome.enable = false;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  services.printing.enable = false;

  # services.flatpak.enable = true;
  # virtualisation.docker.enable = true;
  virtualisation = {
    waydroid.enable = true;
    lxd.enable = true;
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.android = {
    isNormalUser = true;
    description = "android";
    extraGroups = [ "networkmanager" "wheel" "audio" "input" "optical" "storage" "docker" ];
    packages = with pkgs; [
      firefox
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    spice-vdagent
    git
    git-lfs
    killall
    dnsmasq
    dig
    wl-clipboard
    proxychains
    tsocks
    socat
    xfce.thunar
    xfce.tumbler
    gthumb
    feh
    mpv
    ffmpeg
    vlc
    youtube-dl
    yt-dlp
    nmap
    neofetch
    (python3.withPackages(ps: with ps; [ requests ]))
    nettools
    speedtest-cli
    netcat-openbsd
    cmake
    gcc
    p7zip
    gnutar
    gvfs
    gnome.gvfs
    libelf
    tmux
    plocate
    wireguard-go
    wireguard-tools
    go
    whois
    android-tools
    scrcpy
    squid
    openvpn
    networkmanager-openvpn
    gnome.networkmanager-openvpn
    unzip
    rar
    pkg-config
    jq
    fzf
    phoc
    cage
    weston
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # programs.kdeconnect.enable = true;

  # List services that you want to enable:
  #services.cage.enable = true;
  #services.weston.enable = true;
  #services.gdm.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # ADD_SHAREPOINT_SECTION_HERE

  # ADD_WIREGUARD_SECTION_HERE

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

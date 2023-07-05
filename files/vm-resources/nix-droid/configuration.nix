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
  boot.loader.timeout = 0;

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
  services.xserver.displayManager.startx.enable = true;

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
  security.sudo.wheelNeedsPassword = false;
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
    vim
    wget
    curl
    spice-vdagent
    git
    git-lfs
    killall
    dnsmasq
    dig
    wl-clipboard
    socat
    feh
    mpv
    ffmpeg
    yt-dlp
    nmap
    neofetch
    (python3.withPackages(ps: with ps; [ requests ]))
    nettools
    speedtest-cli
    netcat-openbsd
    p7zip
    gnutar
    gvfs
    tmux
    plocate
    wireguard-go
    wireguard-tools
    whois
    android-tools
    scrcpy
    openvpn
    networkmanager-openvpn
    riseup-vpn
    unzip
    rar
    pkg-config
    jq
    fzf
    weston
    lzip
  ];

  # List services that you want to enable:
  services.getty.autologinUser = "android";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  systemd.user.services.weston = {
    enable = true;
    description = "Weston, a Wayland compositor, as a user service";
    unitConfig = {};
    serviceConfig = {
      Type = "simple";
      TimeoutStartSec = "0";
      ExecStart = "/run/current-system/sw/bin/weston";
    };
    wantedBy = [ "default.target" ];
  };

  systemd.services.ipforward = {
    enable = true;
    description = "Socat IP Forwarding for Waydroid";
    unitConfig = {
      Requires = "network.target";
      After = "network.target";
    };
    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/socat tcp-listen:5555,fork,reuseaddr tcp:192.168.240.112:5555";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.rust-forward1 = {
    enable = true;
    description = "Socat IP Forwarding for Rustdesk (1)";
    unitConfig = {
      Requires = "network.target";
      After = "network.target";
    };
    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/socat tcp-listen:21115,fork,reuseaddr tcp:10.152.152.15:21115";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.rust-forward2 = {
    enable = true;
    description = "Socat IP Forwarding for Rustdesk (2)";
    unitConfig = {
      Requires = "network.target";
      After = "network.target";
    };
    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/socat tcp-listen:21116,fork,reuseaddr tcp:10.152.152.15:21116";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.rust-forward2udp = {
    enable = true;
    description = "Socat IP Forwarding for Rustdesk (2udp)";
    unitConfig = {
      Requires = "network.target";
      After = "network.target";
    };
    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/socat udp-listen:21116,fork,reuseaddr udp:10.152.152.15:21116";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.rust-forward3 = {
    enable = true;
    description = "Socat IP Forwarding for Rustdesk (3)";
    unitConfig = {
      Requires = "network.target";
      After = "network.target";
    };
    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/socat tcp-listen:21117,fork,reuseaddr tcp:10.152.152.15:21117";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };

   systemd.services.rust-forward4 = {
    enable = true;
    description = "Socat IP Forwarding for Rustdesk (4)";
    unitConfig = {
      Requires = "network.target";
      After = "network.target";
    };
    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/socat tcp-listen:21118,fork,reuseaddr tcp:10.152.152.15:21118";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.rust-forward5 = {
    enable = true;
    description = "Socat IP Forwarding for Rustdesk (5)";
    unitConfig = {
      Requires = "network.target";
      After = "network.target";
    };
    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/socat tcp-listen:21119,fork,reuseaddr tcp:10.152.152.15:21119";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.user.services.waydroid-session = {
    enable = true;
    description = "Waydroid Service";
    unitConfig = {};
    serviceConfig = {
      Type="simple";
      ExecStart = "/home/android/bin/waydroid-start";
    };
    wantedBy = [ "default.target" ];
  };



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

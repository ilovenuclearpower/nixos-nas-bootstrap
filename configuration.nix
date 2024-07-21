{ config, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/virtualbox-demo.nix> ];
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "7bfb60f7";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
    environment.systemPackages = with pkgs; [ (python3.withPackages(ps: with ps; [
    numpy
    setuptools
    wheel
    pip
##    (buildPythonPackage rec {
##      pname = "diskinfo";
##      version = "3.1.2";
##      src = fetchPypi {
##        inherit pname version;
##          sha256 = "3f60a6f7b72dbf079c7f828540d38078e977aa5f578aa80a6e50b5860ffeaaa1";
##    };
##    doCheck = false;
##  })
  ]))
   git
   vim
];




  # Let demo build as a trusted user.
# nix.settings.trusted-users = [ "demo" ];

# Mount a VirtualBox shared folder.
# This is configurable in the VirtualBox menu at
# Machine / Settings / Shared Folders.
# fileSystems."/mnt" = {
#   fsType = "vboxsf";
#   device = "nameofdevicetomount";
#   options = [ "rw" ];
# };

# By default, the NixOS VirtualBox demo image includes SDDM and Plasma.
# If you prefer another desktop manager or display manager, you may want
# to disable the default.
# services.xserver.desktopManager.plasma5.enable = lib.mkForce false;
# services.displayManager.sddm.enable = lib.mkForce false;

# Enable GDM/GNOME by uncommenting above two lines and two lines below.
# services.xserver.displayManager.gdm.enable = true;
# services.xserver.desktopManager.gnome.enable = true;

# Set your time zone.
# time.timeZone = "Europe/Amsterdam";

# List packages installed in system profile. To search, run:
# \$ nix search wget
# environment.systemPackages = with pkgs; [
#   wget vim
# ];

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

}

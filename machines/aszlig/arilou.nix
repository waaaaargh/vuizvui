{ config, pkgs, lib, ... }:

with lib;

let
  rootUUID = "e9c95c74-e4cf-41f6-bb45-baf8dd579217";
  swapUUID = "4d172959-5cfd-4164-a46e-fa7be0dfd03a";
  diskID = "usb-Lexar_USB_Flash_Drive_201303211246293590E4-0:0";
in {
  vuizvui.user.aszlig.profiles.workstation.enable = true;
  imports = [ <nixpkgs/nixos/modules/profiles/all-hardware.nix> ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.kernelModules = [ "fbcon" "usb_storage" ];
    loader.grub.device = "/dev/disk/by-id/${diskID}";
    loader.grub.memtest86.enable = true;
  };

  networking.hostName = "arilou";
  networking.wireless.enable = true;
  networking.enableB43Firmware = true;

  fileSystems."/".device = "/dev/disk/by-uuid/${rootUUID}";
  fileSystems."/".fsType = "btrfs";
  fileSystems."/".options = concatStringsSep "," [
    "ssd"
    "space_cache"
    "compress-force=zlib"
    "noatime"
  ];

  fileSystems."/tmp".device = "none";
  fileSystems."/tmp".fsType = "tmpfs";
  fileSystems."/tmp".options = "nosuid,nodev,relatime";

  swapDevices = singleton {
    device = "/dev/disk/by-uuid/${swapUUID}";
  };

  services.openssh.enable = mkForce false;
  services.xserver.videoDrivers = [ "intel" "ati" "nouveau" ];

  nix.maxJobs = mkForce 2;
}

# Arch Linux Installation Scripts

1. Boot up PC using an Arch Linux Installation Medium
2. Connect to the internet using ethernet or iwd
    - `iwctl`
    - `device list`
    - `device <YOUR_DEVICE> set-property Powered on`
    - `adapter <YOUR_ADAPTER> set-property Powered on`
    - `station <YOUR_DEVICE> scan`
    - `station <YOUR_DEVICE> get-networks`
    - `station <YOUR_DEVICE> connect <YOUR_SSID>`
    - `exit` && `ping archlinux.org` to check
3. Install git by running `pacman-key --init && pacman -Sy && pacman -S git glibc`
4. Clone this repo by running `git clone https://github.com/ethmth/arch-install.git /root/arch-install`
5. Run `/root/arch-install/scripts/01-installer/01-packages-time.sh` and follow the instructions.


## chroot-ing into encrypted systems

```sh
lsblk

cryptsetup open /dev/sda2 cryptlvm

mount /dev/mapper/cryptlvm /mnt

mount /dev/sda1 /mnt/boot

arch-chroot /mnt

# Do Stuff
```
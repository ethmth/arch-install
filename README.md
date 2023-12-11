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

## If shutdown during package installation and vmlinuz-linux breaks.

[Arch Linux Post](https://bbs.archlinux.org/viewtopic.php?id=263320)

```sh
# Mount disks
lsblk
cryptsetup open /dev/sda2 cryptlvm
mount /dev/mapper/cryptlvm /mnt
mount /dev/sda1 /mnt/boot

# Connect to internet
iwctl
device list
device <YOUR_DEVICE> set-property Powered on
adapter <YOUR_ADAPTER> set-property Powered on
station <YOUR_DEVICE> scan
station <YOUR_DEVICE> get-networks
station <YOUR_DEVICE> connect <YOUR_SSID>
exit

rm /mnt/var/lib/pacman/db.lck # removes pacman lock

pacstrap -M -G -i -C /mnt/etc/pacman.conf /mnt base linux linux-zen linux-lts linux-firmware nvidia-dkms # omit nvidia if necessary

sudo shutdown -r now

# ============================================
# Once rebooted into hopefully workable system

cat /var/lib/pacman.log # Look at what caused failure, re-install all packages that were part of that transaction

pacman -Qk 2>/dev/null | grep -v ' 0 missing files' # get packages with missing files

yay -S <all packages from above 2 commands>

```

# Downtown Ohio Server

Arch Linux deployment

## Download latest Arch Linux ISO

`http://mirror.arizona.edu/archlinux/iso/`

Boot ISO file in UEFI mode with Secure Boot disabled.

## Set up a password on the Live CD

`passwd` \
 Log into the machine with \
`ssh -o StrictHostKeyChecking=no -o "UserKnownHostsFile /dev/null" root@archiso.local`

## Check internet connect

`ip link` \
`ping google.com`

## Set clock datetime
`timedatectl set-ntp true`

## Check partitions

`fdisk -l`

## Format partitions

`mkfs.xfs -f /dev/block` \
`mkswap /dev/swap_partition`

## Mount partitions

`mount /dev/root_partition /mnt` \
`mount --mkdir /dev/efi_system_partition /mnt/boot` \
`swapon /dev/swap_partition`

## Select mirrors list

Route `/etc/pacman.d/mirrorlist` \
Arizona Univeristy mirror `http://mirror.arizona.edu/archlinux/$repo/os/$arch`

## Install main packages

``pacstrap -K /mnt base base-devel linux linux-firmware intel-ucode networkmanager xfsprogs vim git man-db man-pages``


## Generate fstab

`genfstab -U /mnt >> /mnt/etc/fstab`

## Change root into new system

`arch-chroot /mnt`

## Set time zone

`ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime`

## Run hwclock

`hwclock --systohc`

## Edit `/etc/locale.gen` and uncomment `en_US.UTF-8 UTF-8`

`locale-gen`

## Create locale.conf

`vim /etc/locale.conf` \
`LANG=en_US.UTF-8`

## Create vconsole.conf

`vim /etc/vconsole.conf` \
`FONT=arm8`

## Create hostname

``echo "mustang" >> /etc/hostname``

## Set hosts in `/etc/hosts`

````
#<ip-address>
127.0.0.1	localhost
::1		localhost
````

## Enable services

``systemctl enable NetworkManager`` \
``systemctl enable fstrim.timer``

## Creating a new initramfs

``mkinitcpio -P``

## Create bootloader

``bootctl install`` \

Edit loader.conf file
````
cat > /boot/loader/loader.conf <<EOD
default arch.conf
timeout 3
console-mode max
editor no
EOD
````
Create arch.conf file

````
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=PARTUUID= rw
````

````
title Arch Fallback
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux-fallback.img
options root=PARTUUID= rw
````

Append PARTUUID with this line \
``$(blkid /dev/partition -s PARTUUID -o value)``

## Set root password
``passdw``


## Exit and Reboot

``exit``
``umount -R /mnt``

## Install new packages

``pacman -S ufw openssh

## Firewall setup

````
ufw allow 28015
ufw allow 28016
ufw allow 17151
ufw allow 26030/tcp
ufw enable
ufw status verbose
sudo systemctl enable ufw
````

## SSH server setup

````
vim /etc/ssh/sshd_config
Port 26030
systemctl enable sshd
systemctl start sshd
````

## Create user
````
useradd -mg wheel rusty
passwd rusty
vim /etc/sudoers
uncoment %wheel ALL
````

## Login into ssh with rusty user
``cat C:\Users\fuzzj\.ssh\id_rsa.pub | ssh -p 26030 rusty@192.168.1.17 "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && cat >> ~/.ssh/authorized_keys"``

## Set password authentication NO
``sudo vim /etc/ssh/sshd_config``
``sudo systemctl restart sshd``
``ssh-copy-id -p 26030 rusty@181.32.230.19``

## Set up static ip

````
nmcli con mod "Wired connection 1" \
    connection.autoconnect yes \
    ipv4.method manual \
    ipv4.ignore-auto-dns true
  ipv4.addresses "192.168.1.17/30" \
  ipv4.gateway "192.168.1.1" \
  ipv4.dns "1.1.1.1,1.0.0.1" \
````
## Install YAY

````
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
````

## Install SteamCMD

``yay -S steamcmd``

## Create Rust folder

````
mkdir Steam
mkdir Steam/Rust
````
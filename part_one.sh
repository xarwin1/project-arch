#!/bin/bash

# PKGS to be installed
PKGS="$(awk '{print}' pkglists.txt)"

echo "Before running this script, ensure that you are connected to the internet.
You can check the connection with the command \"ping google.com\". And make sure that
you know how to partition your drive according to your likings because this script can't
handle that for now."

lsblk

echo "Please select a drive to partition using cfdisk based on the lsblk output above (ex. /dev/sdX or /dev/nvmeXXXX)"
read DISK_TO_PART

cfdisk $DISK_TO_PART

lsblk

echo "Please enter your efi partition (ex. /dev/sdxX)"
read EFI_PARTITION

echo "Enter your swap partition"
read SWAP_PARTITION

echo "Enter your root partition"
read ROOT_PARTITION

echo "Formatting all the partitions..."
echo "Formatting the efi partition to FAT32..."
mkfs.fat -F 32 $EFI_PARTITION
echo "Assigning swap on swap parition..."
mkswap $SWAP_PARTITION
swapon $SWAP_PARTITION
echo "Formatting the root partition to ext4..."
mkfs.ext4 $ROOT_PARTITION

echo "Mounting partitions on appropriate directories..."
mount $ROOT_PARTITION /mnt
mount --mkdir $EFI_PARTITION /mnt/boot

echo "Installing packages to new root..."
sed -i "s/#ParallelDownloads =5/ParallelDownloads = 5/" /etc/pacman.conf
pacstrap -K /mnt $PKGS

genfstab -U /mnt >> /mnt/etc/fstab
sed -i "s/#ParallelDownloads =5/ParallelDownloads = 5/" /mnt/etc/pacman.conf
cp part_two.sh /mnt

echo "Part one of installation complete. Please go to the tmp directory with \"cd /tmp\" and
give the script permission to run with \"chmod u+x part_two.sh\"."
arch-chroot /mnt


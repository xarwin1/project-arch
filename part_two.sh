echo "
This is the part two of the installation script.
Only execute this after a succesful part one installation
"

echo "Enter your zoneinfo (ex. Asia/Manila America/Toronto)
refer to https://en.wikipedia.org/wiki/List_of_tz_database_time_zones and look for your TZ identifier
if you don't know your zoneinfo."

read ZONEINFO

ln -sf /usr/share/zoneinfo/$ZONEINFO /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" >> /etc/locale.conf

echo "Enter your hostname (computer name)"
read HOSTNAME

echo $HOSTNAME >> /etc/hostname

echo "Setting your root password..."
passwd

echo "Creating a user account"
echo "Enter a username"
read USER_NAME
useradd -m -G $USER_NAME"

passwd $USER_NAME
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

systemctl enable NetworkManager
systemctl enable lightdm

echo "Installing the bootloader..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "Installation finished. You can now reboot your computer."
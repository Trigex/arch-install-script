#!/bin/bash
# Chroot section of the install script

waitForUserInput() { read -n 1 -s -r -p "Press any key to continue" }

hostsTemplate = ""

installer() {
    ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
    hwclock --systohc
    echo "Uncomment en_US"
    waitForUserInput
    vim /etc/locale.gen
    locale-gen
    echo "LANG=en_US.UTF-8" > /etc/locale.conf
    read -p "Enter hostname: " hostname
    echo $hostname > /etc/hostname
    # puts hostname in hosts template 
    sed -e "s/\${i}/1/" -e "s/\${hostname}/dog/" -e "s/\${i}/1/" -e "s/\${hostname}/dog/" hosts_template > /etc/hosts
    echo "Set root password"
    passwd
    pacman -S amd-ucode
    # install bootloader
    grub-install --target=i386-pc /dev/sda
    # generate bootloader config
    grub-mkconfig -o /boot/grub/grub.cfg
    echo "Install completed! Exiting chroot and rebooting..."
    waitForUserInput
    exit
}

installer

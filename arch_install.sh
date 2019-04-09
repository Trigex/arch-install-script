#!/bin/bash
# A quick and dirty script to automate Arch installs for my personal consumption
# It probably won't setup the system the way you'd like, but feel free to modify
# Expects MBR boot mode

waitForUserInput() { read -n 1 -s -r -p "Press any key to continue"; }

installer() {
    echo "arch_installer.sh started..."
    echo "Connect to wifi..."
    # get wifi connection
    # this is a bit retarded since I probably already setup wifi to clone this repo on the live image but whatever
    waitForUserInput
    wifi-menu
    # ensure system clock is accurate
    timedatectl set-ntp true
    echo "Partition disk /dev/sda"
    waitForUserInput
    cfdisk /dev/sda
    # expects sda1 to be root, sda2 to be swap, sda3 to be home. Maybe I'll set these to be user selected at some point?
    echo "Formating partitions..."
    waitForUserInput
    # format partitions
    mkfs.ext4 /dev/sda1
    mkfs.ext4 /dev/sda3
    mkswap /dev/sda2
    swapon /dev/sda2
    # mount partitions
    mount /dev/sda1 /mnt
    mkdir /mnt/home
    mount /dev/sda3 /mnt/home
    # pacstrap
    pacstrap /mnt base base-devel networkmanager grub vim
    # fstab
    genfstab -U /mnt >> /mnt/etc/fstab
    # copy chroot script
    cp arch_install_chroot.sh /mnt
    # copy hosts template
    cp hosts_template /mnt
    # run chroot script
    arch-chroot /mnt ./arch_install_chroot.sh
    # clean up
    rm /mnt/arch_install_chroot
    rm /mnt/hosts_template
    # reboot post chroot section
    reboot
}

installer

#!/bin/bash
# Post main install, general setup. This is the part where it gets very specific to me! Again, modify as you please lol

setup() {
    echo "Post install setup!!!"
    echo "Adding new user..."
    read -p "Enter username: " username
    useradd -m -G wheel $username
    passwd $username
    EDITOR=vim visudo
    vim /etc/pacman.conf
    pacman -Sy
    pacman -S xf86-video-vesa mesa
    pacman -S xf86-video-intel lib32-mesa-libgl
    pacman -S xorg-server xorg-xinit
    echo "That should be enough, install whatever DE you want"
}

setup

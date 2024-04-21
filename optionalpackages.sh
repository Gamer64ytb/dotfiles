#!/bin/bash

# Define packages to be installed with pacman
pacman_packages=(
    font-manager
    gnome-software
    nwg-look
    btop
    nvim
    goverlay
)

# Define packages to be installed with yay
yay_packages=(
    appimagelauncher
    visual-studio-code-bin
)

# Install packages with pacman
for pkg in "${pacman_packages[@]}"; do
    echo "Installing $pkg with pacman..."
    sudo pacman -S --noconfirm $pkg
    sleep 2 # Delay for readability and control
done

# Install packages with yay
for pkg in "${yay_packages[@]}"; do
    echo "Installing $pkg with yay..."
    yay -S --noconfirm $pkg
    sleep 2 # Delay for readability and control
done

echo "All optionalpackages have been installed."

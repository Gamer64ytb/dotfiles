#!/bin/bash

echo "Updating system..."
sudo pacman -Syu

echo "Cleaning orphan packages..."
sudo pacman -Qdtq | sudo pacman -Rns -

echo "Cleaning orphan caches..."
sudo pacman -Sc

echo "System updated successfully, a reboot may be required."

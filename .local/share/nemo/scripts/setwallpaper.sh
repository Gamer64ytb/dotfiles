#!/bin/bash

# Check if the script received exactly one argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_wallpaper>"
    exit 1
fi

# The full path to the wallpaper is the first argument
wallpaper_path="$1"

# Extract the directory and wallpaper name from the path
working_directory=$(dirname "$wallpaper_path")
wallpaper_name=$(basename "$wallpaper_path")

# Use swaybg with the -i flag to set the wallpaper
swaybg -i "${wallpaper_path}" &

# sleep

sleep 1

# Use wal to set the colorscheme based on the wallpaper
~/.local/bin/wal -i "${wallpaper_path}"

# Copy the generated color scheme files to their respective locations
cp -f "${HOME}"/.cache/wal/pywal.json "${HOME}"/.config/presets/user/pywal.json
cp "${HOME}"/.cache/wal/pywal.kvconfig "${HOME}"/.config/Kvantum/pywal/pywal.kvconfig
cp "${HOME}"/.cache/wal/pywal.svg "${HOME}"/.config/Kvantum/pywal/pywal.svg

# Restart Waybar to apply the new color scheme
~/dotfiles/restartwaybar.sh

# Apply the pywal theme to GTK applications using gradience-cli
gradience-cli apply -n pywal --gtk both
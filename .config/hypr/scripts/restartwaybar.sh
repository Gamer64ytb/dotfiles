#!/bin/bash

# Function to check if a process is running
is_process_running() {
    pgrep "$1" >/dev/null 2>&1
}

# Check if waybar is running
if is_process_running "waybar"; then
    echo "waybar is running. Restarting..."
    killall waybar
    waybar &
else
    echo "waybar is not running."
fi

# Check if swaync is running
if is_process_running "swaync"; then
    echo "swaync is running. Restarting..."
    killall swaync
    swaync &
else
    echo "swaync is not running."
fi

echo "Done"

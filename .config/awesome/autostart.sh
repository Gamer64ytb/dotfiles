#!/bin/bash

# Check if Mailspring is already running, if not, start it quietly in the background
if ! pgrep -x "mailspring" > /dev/null; then
    flatpak run com.getmailspring.Mailspring --password-store="gnome-libsecret" -m &> /dev/null &
fi

# Check if Discord is already running, if not, start it quietly in the background
if ! pgrep -x "discord" > /dev/null; then
    flatpak run com.discordapp.Discord -m &> /dev/null &
fi

# Check if Syncthingtray-qt6 is already running, if not, start it quietly in the background
if ! pgrep -x "syncthingtray-qt6" > /dev/null; then
    syncthingtray-qt6 &> /dev/null &
fi

#!/bin/bash

# Additional commands after package installation

# Start daemons
echo "Starting services..."
sudo systemctl enable power-profiles-daemon.service
sudo systemctl start power-profiles-daemon.service
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# Uninstall useless packages
sudo pacman -Rsn kitty dunst dolphin vim wofi sddm

# Update the user directories
echo "Updating user directories..."
xdg-user-dirs-update

# Run stow to sync dotfiles
echo "Syncing dotfiles with stow..."
stow .

# Set adw-gtk3 theme
echo "Setting gtk theme..."
flatpak install org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
# Default terminal
gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty

# Set kvantun theme to pywal
kvantummanager --set pywal



# Install pywal16
echo "Installing pywall16..."
pipx ensurepath
pipx install pywal16

# Use the pywal GTK theme for flatpak
echo "Configuring flatpak to use the pywal GTK theme..."
sudo flatpak override --filesystem=xdg-config/gtk-4.0
sudo flatpak override --filesystem=xdg-config/gtk-3.0
sudo flatpak override --filesystem=xdg-config/Kvantum:ro
sudo flatpak override --env=QT_STYLE_OVERRIDE=kvantum
flatpak install org.kde.KStyle.Kvantum/x86_64/5.15-22.08 org.kde.KStyle.Kvantum/x86_64/5.15-23.08 org.kde.KStyle.Kvantum/x86_64/6.5 org.kde.KStyle.Kvantum/x86_64/6.6 org.kde.KStyle.Kvantum/x86_64/5.15 org.kde.KStyle.Kvantum/x86_64/5.15-21.08

# Install oh-my-zsh
echo "Installing oh-my-zsh and plugins..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sleep 1
stow .
sleep 1
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sleep 1
# Change default shell to zsh
chsh -s /bin/zsh
# Delelte generated zshrc
rm ~/.zshrc
# Put custom zshrc
stow .
# zsh-syntax-highlighting plugin
# Need fixing
sleep 1
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
# zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
sleep 1

# Autologin
echo "Configuring autologin..."
# Detect the current username
USERNAME=$(whoami)

# Create a systemd service override directory for getty@tty1
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d

# Create the override file to enable auto-login
echo "[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $USERNAME --noclear %I \$TERM" | sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf > /dev/null

# Add Hyprland startup command to the user's shell profile if not already present
HYPR_STARTUP="if [ -z \"\$DISPLAY\" ] && [ \"\$(tty)\" = \"/dev/tty1\" ]; then exec Hyprland; fi"

# Determine the shell and its profile file
SHELL=$(getent passwd $USERNAME | cut -d: -f7)
PROFILE_FILE=""

if [[ "$SHELL" == */bash ]]; then
    PROFILE_FILE="$HOME/.bash_profile"
elif [[ "$SHELL" == */zsh ]]; then
    PROFILE_FILE="$HOME/.zprofile"
else
    echo "Unsupported shell. Please manually configure your shell to start Hyprland."
    exit 1
fi

# Append Hyprland startup command to profile if it doesn't already exist
if ! grep -q "exec hyprland" "$PROFILE_FILE"; then
    echo "$HYPR_STARTUP" >> "$PROFILE_FILE"
fi

# Reload systemd to apply changes
sudo systemctl daemon-reload

# Enable getty@tty1.service
sudo systemctl enable getty@tty1.service

echo "Auto-login and Hyprland startup configuration complete. Please reboot."

echo "Configuration complete."

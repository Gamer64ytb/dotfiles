#!/bin/bash

# Define packages to be installed with pacman
# Install packages with pacman
sudo pacman -S --noconfirm \
    stow \
    xdg-desktop-portal-gtk \
    thunar \
    picom \
    flameshot \
    xclip \
    polybar \
    alacritty \
    zsh \
    power-profiles-daemon \
    gnome-disk-utility \
    brightnessctl \
    flatpak \
    gvfs \
    gvfs-mtp \
    xdg-user-dirs \
    network-manager-applet \
    blueman \
    bluez-utils \
    eza \
    bluez \
    qt6-svg \
    qt6-declarative \
    ttf-font-awesome \
    qt5ct \
    qt6ct \
    grim \
    slurp \
    udiskie \
    kvantum \
    kvantum-qt5 \
    cliphist \
    pamixer \
    playerctl \
    pavucontrol \
    gnome-keyring \
    lxrandr \
    rofi \
    fastfetch \
    amd-ucode \
    xf86-video-amdgpu \
    mousepad \
    sddm

# Install packages with yay
yay -S --noconfirm \
    xfce-polkit \
    rofi-greenclip \
    waypaper-git \
    pywal-16-colors \
    pywal-discord-git

# Install packages with yay
for pkg in "${yay_packages[@]}"; do
    echo "Installing $pkg with yay..."
    yay -S --noconfirm $pkg
    sleep 2 # Delay for readability and control
done

echo "All packages have been installed."

# Make .local if it doesnt exist so stow doesnt symlink the entire .local folder
mkdir -p ~/.local
mkdir ~/.local/share

# Run stow to sync dotfiles
echo "Syncing dotfiles with stow..."
stow .

# Start daemons
echo "Starting services..."
sudo systemctl enable power-profiles-daemon.service
sudo systemctl start power-profiles-daemon.service
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
sudo systemctl enable sddm
sudo systemctl set-default graphical.target

# Set default terminal as Alacritty
echo "Default terminal as Alacritty..."
gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty

# Uninstall useless packages
sudo pacman -Rsn xterm vim

# Update the user directories
echo "Updating user directories..."
xdg-user-dirs-update

# Use the pywal theme for flatpak and GTK4

flatpak install gradience -y
flatpak install org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark -y
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'


sudo flatpak override --filesystem=xdg-config/gtk-4.0
sudo flatpak override --filesystem=xdg-config/gtk-3.0
sudo flatpak override --filesystem=xdg-config/Kvantum:ro
sudo flatpak override --env=QT_STYLE_OVERRIDE=kvantum
flatpak install org.kde.KStyle.Kvantum/x86_64/5.15-22.08 org.kde.KStyle.Kvantum/x86_64/5.15-23.08 org.kde.KStyle.Kvantum/x86_64/6.5 org.kde.KStyle.Kvantum/x86_64/6.6 org.kde.KStyle.Kvantum/x86_64/5.15 org.kde.KStyle.Kvantum/x86_64/5.15-21.08

# Change default shell to zsh
echo "Changing shell to ZSH..."
chsh -s /bin/zsh

# Make SDDM conf
sudo touch /etc/sddm.conf

# Create a backup of the SDDM configuration file
echo "Creating a backup of the SDDM configuration file..."
sudo cp /etc/sddm.conf /etc/sddm.conf.bak

# Set up SDDM theme
echo "Setting up sddm theme..."
sudo cp -r  ~/dotfiles/sddm/catppuccin-macchiato/ /usr/share/sddm/themes/
sudo sed -i.bak '/\[Theme\]/,/^\[/s/.*//g' /etc/sddm.conf && echo -e "[Theme]\nCurrent=catppuccin-macchiato" | sudo tee -a /etc/sddm.conf

# Ask the user if they would like to install a lock screen
read -p "Would you like to install a lock screen? (yes/no): " answer
if [ "$answer" == "yes" ]; then
    echo "Installing lockscreen..."
    yay -S --noconfirm i3lock-color-git
    sudo pacman -S --noconfirm imagemagick awk
    git clone https://github.com/meskarune/i3lock-fancy.git
    cd i3lock-fancy
    sudo make install
else
    echo "Skipping lockscreen."
fi

# Ask the user if they would like to reboot
read -p "Would you like to reboot now? (yes/no): " answer
if [ "$answer" == "yes" ]; then
    echo "Rebooting..."
    sudo reboot
else
    echo "Skipping reboot."
fi

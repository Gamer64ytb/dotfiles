# wip script
# ask the user if they would like to install Oh My Zsh
read -p "Would you like to install Oh My Zsh? (yes/no): " answer
if [ "$answer" == "yes" ]; then
    echo "Installing oh-my-zsh and plugins..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    sleep 1
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    sleep 1
    # Delelte generated zshrc
    rm ~/.zshrc
    # Put custom zshrc
    stow .
    # zsh-syntax-highlighting plugin
    sleep 1
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    # zsh-autosuggestions plugin
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    sleep 1
else
    echo "Skipping Oh My Zsh installation."
fi

echo "Done."

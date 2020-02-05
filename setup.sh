#!/bin/bash

set -e
source scripts/get_os.sh
OS=$(getOS)

if [ $# -eq 0 ]
then
    echo "No arguments supplied."
    echo "  --all : Set sym links, install software, and install vim plugins"
    echo "  --links : Set sym links only"
    echo "  --sw : Install software only"
    echo "  --vim : Install vim plugins only"
    echo "  --update : Update tmux plugins, vim plugins, and recompile YouCompleteMe"
    exit 1
fi

LINKS="false"
SW="false"
VIM="false"
UPDATE="false"

if  [[ $1 = "--all" ]]; then
    echo "Option --all turned on"
    LINKS="true"
    SW="true"
    VIM="true"
    UPDATE="false" #don't update - we just installed
else
    echo "Option --all not used"
fi

if  [[ $1 = "--links" ]]; then
    echo "Option --links turned on"
    LINKS="true"
else
    echo "Option --links not used"
fi

if  [[ $1 = "--sw" ]]; then
    echo "Option --sw turned on"
    SW="true"
else
    echo "Option --sw not used"
fi

if  [[ $1 = "--vim" ]]; then
    echo "Option --vim turned on"
    VIM="true"
else
    echo "Option --vim not used"
fi

if  [[ $1 = "--update" ]]; then
    echo "Option --update turned on"
    UPDATE="true"
else
    echo "Option --update not used"
fi

# Note: Won't be able to run this on macOS yet.  I had to just go through the
# different sections manually to apply the required updates and fix any issues
# that arised.  In particular, I had to:
# * update bash version to > 4.0 (default is 3.x)
# * use .bash_profile, instead of .bashrc

# Get path to current script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$LINKS" = "true" ]; then
    echo "Setting up sym links..."

    # Create sym links to config files:
    ln -sf "$DIR"/bash/bash_aliases ~/.bash_aliases
    ln -sf "$DIR"/bash/agignore ~/.agignore
    ln -sf "$DIR"/bash/dircolors ~/.dircolors
    ln -sf "$DIR"/bash/inputrc ~/.inputrc
    ln -sf "$DIR"/bash/my_grep ~/.my_grep
    sudo ln -sf "$DIR"/bash/ta /etc/bash_completion.d/ta
    if [[ $OS = "Mac" ]]; then
        ln -sf "$DIR"/bash/bash_profile.mac ~/.bash_profile
    fi

    ln -sf "$DIR"/git/gitignore ~/.gitignore
    ln -sf "$DIR"/git/gitconfig ~/.gitconfig

    ln -sf "$DIR"/tmux/tmux.conf ~/.tmux.conf

    ln -sf "$DIR"/vim/vimrc ~/.vimrc
    ln -sf "$DIR"/vim/vimrc_common ~/.vimrc_common
    ln -sf "$DIR"/vim ~/.vim

    ln -sf "$DIR"/jetbrains/ideavimrc ~/.ideavimrc

    if [[ $OS = "Linux" ]]; then
        mkdir -p $HOME/.config/Code/User
        ln -sf "$DIR"/vscode/settings.json $HOME/.config/Code/User/settings.json
        ln -sf "$DIR"/vscode/keybindings.json $HOME/.config/Code/User/keybindings.json
    elif [[ $OS = "Mac" ]]; then
        mkdir -p $HOME/Library/Application Support/Code/User
        ln -sf "$DIR"/vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"
        ln -sf "$DIR"/vscode/keybindings.json "$HOME/Library/Application Support/Code/User/keybindings.json"
    fi

    # create link to dropbox vimwiki directory from default vimwiki location:
    ln -sf ~/Dropbox/vimwiki ~/vimwiki
fi

if [ "$SW" = "true" ]; then
    echo "Installing necessary software..."

    sudo apt-get update

    # check if vim installed.  If not, install it.
    if hash vim 2>/dev/null; then
        echo "vim already installed."
    else
        echo "vim not installed. Installing..."
        sudo apt-get install -y vim vim-gtk
    fi

    if hash tmux 2>/dev/null; then
        echo "tmux already installed."
    else
        echo "tmux not installed. Installing..."
        sudo apt-get install -y tmux
    fi

    # clone tmux plugin manager:
    echo "Installing tmux plugins..."
    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
    # install plugins:
    ~/.tmux/plugins/tpm/bin/install_plugins

    # clone silver searcher:
    echo "Installing silver searcher..."
    if [ ! -d "$DIR"/the_silver_searcher ]; then
        git clone https://github.com/ggreer/the_silver_searcher.git
    fi
    sudo apt-get install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
    cd the_silver_searcher
    ./build.sh
    sudo make install
    cd ..
fi

if [ "$VIM" = "true" ]; then
    echo "Installing vim plugins..."

    # Install vim vundle plugin manager:
    if [ ! -d "$DIR"/vim/bundle/Vundle.vim ]; then
        echo "Installing Vundle..."
        git clone https://github.com/VundleVim/Vundle.vim.git "$DIR"/vim/bundle/Vundle.vim
    else
        echo ""$DIR"/vim/bundle/Vundle.vim already exists.  No need to clone."
    fi

    # Now install all vim plugins
    echo "Installing vim plugins..."
    echo '\n' | vim +PluginInstall +qall
    echo '\n' | vim +PluginUpdate +qall
fi

if [ "$UPDATE" = "true" ]; then
    # update all vim plugins
    echo "Updating vim plugins..."
    echo '\n' | vim +PluginInstall +qall
    echo '\n' | vim +PluginUpdate +qall

    # install plugins:
    ~/.tmux/plugins/tpm/bin/install_plugins
fi

echo "Setup complete!"

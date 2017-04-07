#!/usr/bin/env bash



NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2; tput bold)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
 
function red() {
    echo -e "$RED$*$NORMAL"
}
 
function green() {
    echo -e "$GREEN$*$NORMAL"
}
 
function yellow() {
    echo -e "$YELLOW$*$NORMAL"
}



BASE_DIR=/tmp/mac-init


init() {
    rm -rf $BASE_DIR
    mkdir -p $BASE_DIR
}



wait_for_me() {
    read -r "Press any key to continue..."
}


# generate ssh keys for github and other uses
gen_ssh_keys() {
    yellow "SSH KEYS:"
    test -d ~/.ssh/ || mkdir ~/.ssh
    f=~/.ssh/id_ed25519
    test -f $f || (ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N '' && wait_for_me)
}

 
clone_repos() {
    yellow "CLONE REPOS:"
    test -d ~/Config || git clone git@github.com:hangyan/Config.git ~/Config
    test -d ~/.emacs.d/ || git clone git@github.com:hangyan/emacs.d.git ~/.emacs.d
    test -d ~/Code || git clone git@github.com:hangyan/Code.git ~/Code
}


install_brew() {
    # install brew
    yellow "BREW:"

    if ! type "brew" > /dev/null; then
        yellow "Install brew..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
}


set_osx() {
    yellow "OSX:"
   # Unhide User Library Folder
    chflags nohidden ~/Library

    # Show "Quit Finder" Menu Item
    defaults write com.apple.finder QuitMenuItem -bool true 

    # link to icloud
    [ ! -L iCloud ] || ln -s ~/Library/Mobile\ Documents/com\~apple\~CloudDocs ~/iCloud
 
}


brew_check_all() {
	declare -a tools=('pgcli' 'npm'  'markdown' 'thefuck' 'fish' \
							  'httpie' 'jq' 'icdiff' 'htop-osx' 'mtr' 'cmake' \
							  'zsh' 'p7zip' 'svn' 'python' 'git' 'emacs' \
							  'ccat' 'ruby' 'ssh-copy-id' 'cloc' 'spark' \
                                                          'chezscheme' 'python' 'zsh-completions' 'zsh-syntax-highlighting' \
                                                          'aira2')
	for i in "${tools[@]}"; do
		echo "Checking $i..."
		brew info $i | grep -q "Not installed"
		[[ $? -eq 0 ]] && echo -e "Installing $tool..." && brew install $i
	done

}

brew_cask_check_all() {
	declare -a tools=('shiftit')
	for i in "${tools[@]}"; do
		echo "Cask Checking $i..."
		brew cask info $i | grep -q "Not installed"
		[[ $? -eq 0 ]] && echo -e "Installing $tool..." && brew cask install $i
	done
}

brew_install_all() {
    yellow "BREW INSTALL:"
    brew_check_all
    brew_cask_check_all

}


new_zsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    ln -sf ~/Config/zshrc ~/.zshrc
    ln -sf ~/Config/zshenv ~/.zshenv
}

install_zsh() {
    yellow "ZSH:"
    test -d ~/.oh-my-zsh/ || new_zsh
}

set_git() {
    test -f ~/.gitconfig || ln -sf ~/Config/git/gitconfig ~/.gitconfig
}


_change_sudo() {
    f=/etc/sudoers
    me=$(whoami)
    sudo cp $f $BASE_DIR/
    sudo chown "$me" $BASE_DIR/$f
    echo "$me ALL=(ALL) NOPASSSWD: ALL" >> $BASE_DIR/$f
    sudo mv $BASE_DIR/$f $f
    sudo chmod -w $f
}

change_sudo() {
    yellow "SUDO:"
    me=$(whoami)
    sudo grep "$me ALL" /etc/sudoers || _change_sudo
}


pip_install() {
    pip install ipython yapf autopep8 flake8 isort pylint jedi
}

configure_vim() {
    git clone git://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_basic_vimrc.sh
}

main() {
    init
    gen_ssh_keys
    # upload the key to github done
    clone_repos
    install_brew
    set_osx
    set_git
    change_sudo
    brew_install_all
    install_zsh
    pip_install
    configure_vim
}

main

#!/usr/bin/env bash

NORMAL=$(tput sgr0)
GREEN=$(
  tput setaf 2
  tput bold
)
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
  yellow "--Config"
  test -d ~/Config || git clone git@github.com:hangyan/Config.git ~/Config
  yellow "Code"
  test -d ~/Code || git clone git@github.com:hangyan/Code.git ~/Code
}

_update_brew_remote() {
  cd "$(brew --repo)" || exit
  git remote -v | head -1 | grep "tsinghua.edu.cn" || git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
  cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core" || exit
  git remote -v | head -1 | grep "tsinghua.edu.cn" || (git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git && brew update)
  cd ~
}

install_brew() {
  # install brew
  yellow "BREW:"

  if ! command -v brew; then
    yellow "Install brew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  _update_brew_remote
}

set_osx() {
  yellow "OSX:"
  # Unhide User Library Folder
  chflags nohidden ~/Library

  # Show "Quit Finder" Menu Item
  defaults write com.apple.finder QuitMenuItem -bool true

  # link to icloud
  test -L iCloud || ln -s ~/Library/Mobile\ Documents/com\~apple\~CloudDocs ~/iCloud

}

brew_check_all() {
  declare -a tools=( 'npm' 'markdown' 'thefuck'
    'httpie' 'jq' 'icdiff' 'htop-osx'
    'zsh' 'p7zip'  'python' 'git' 'lsd'
    'ccat' 'ruby' 'ssh-copy-id' 'cloc' 
     'python' 'zsh-completions' 'zsh-syntax-highlighting'
    'wget' 'mas' 'go' 'coreutils' 'exa')
  for i in "${tools[@]}"; do
    echo "Checking $i..."
    brew info $i | grep -q "Not installed"
    [[ $? -eq 0 ]] && echo -e "Installing $tool..." && brew install $i
  done

}

brew_cask_check_all() {
  declare -a tools=('shiftit' 'insomnia')
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

  brew cask info font-hack-nerd-font | grep -q "Not installed"
   [[ $? -eq 0 ]] && echo -e "Installing nerd font..." && brew tap homebrew/cask-fonts && brew cask info font-hack-nerd-font

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
  echo "$me ALL=(ALL) NOPASSSWD: ALL" >>$BASE_DIR/$f
  sudo mv $BASE_DIR/$f $f
  sudo chmod -w $f
}

change_sudo() {
  yellow "SUDO:"
  me=$(whoami)
  sudo grep "$me ALL" /etc/sudoers || _change_sudo
}

pip_install() {
  sudo pip install ipython yapf autopep8 flake8 isort pylint jedi glances mycli importmagic epc ipython >/dev/null
}

install_vim() {
  git clone git://github.com/amix/vimrc.git ~/.vim_runtime
  sh ~/.vim_runtime/install_basic_vimrc.sh
}

configure_vim() {
  yellow "VIM:"
  test -d ~/.vim_runtime || install_vim
}

install_tools() {
  yellow "TOOLS:"
  f=~/Project/
  test -d $f || mkdir $f
  cd $f || exit
  mkdir apps
  yellow "--Item2"
  test -d /Applications/iTerm.app || wget -c https://iterm2.com/downloads/beta/iTerm2-3_0_15.zip
}

install_npm() {
  yellow "CNPM:"
  which cnpm || npm install -g cnpm --registry=https://registry.npm.taobao.org
}

_install_as() {
  id=$(mas search "$1" | head -1 | awk '{print $1}')
  mas install "$id"
}

install_from_appstore() {
  yellow "APPSTORE:"
  yellow "--PopClip"
  test -d /Applications/PopClip.app/ || _install_as PopClip
  yellow "--CopyClip"
  test -d /Applications/CopyClip.app || _install_as "CopyClip"
  yellow "--Quiver"
  test -d /Applications/Quiver.app/ || _install_as Quiver

}

install_golang() {
  which go || exit
  yellow "GOLANG:"
  test -d ~/Golang || mkdir ~/Golang
  #mkdir -p ~/Golang/src/golang.org/x/
  #p=github.com/golang/tools/go
  #test -d ~/Golang/src/$p || go get $p
  #p=github.com/golang/net
  #test -d ~/Golang/src/$p || go get $p
  #test -d ~/Golang/src/golang.org/x/tools || ln -sf ~/Golang/src/github.com/golang/tools/ ~/Golang/src/golang.org/x/tools
  #test -d ~/Golang/src/golang.org/x/net || ln -sf ~/Golang/src/github.com/golang/net/ ~/Golang/src/golang.org/x/net
  which golint || go get -u github.com/golang/lint/golint
  which guru || go install golang.org/x/tools/cmd/guru
  which godoctor || go get github.com/godoctor/godoctor
  #which gometalinter || go get github.com/alecthomas/gometalinter
  which godef || go get github.com/rogpeppe/godef
  which gocode || go get -u github.com/nsf/gocode
  #which govendor || go get -u github.com/kardianos/govendor
  which shfmt || go get -u github.com/mvdan/sh/cmd/shfmt
  #gometalinter --install --update

}

main() {
  init
  gen_ssh_keys
  # upload the key to github done
  clone_repos
  install_brew
  set_osx
  set_git
  #change_sudo
  brew_install_all
  install_tools
  install_npm
  install_zsh
 # pip_install
  configure_vim
  install_from_appstore
  install_golang
}

main

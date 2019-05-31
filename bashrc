# Nothing to see here — Everything's in .bash_profile
[ -n "$PS1" ] && source ~/.bash_profile# Run twolfson/sexy-bash-prompt
. ~/.bash_prompt
# Run twolfson/sexy-bash-prompt
. ~/.bash_prompt

export PATH=/usr/local/go/bin:$PATH

export GOPATH=~/Golang
export GOROOT=/usr/local/go
export PATH=$PATH:$GOPATH/bin:/usr/local/mysql/bin

# brew install exa
alias ls="exa"
alias ll="exa -l"
alias cat="bat"
alias gst="git status"
alias gcb="git checkout -b "
alias gco="git checkout "

# git alias
alias gu='git add --all . && git commit -am "Update" && git push origin'
alias glf='git log --format="%H" -n 1 | pbcopy'
alias gl='git log --oneline --decorate --color'

# util
alias weather='curl wttr.in'

alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

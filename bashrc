# Nothing to see here — Everything's in .bash_profile
[ -n "$PS1" ] && source ~/.bash_profile# Run twolfson/sexy-bash-prompt
. ~/.bash_prompt
# Run twolfson/sexy-bash-prompt
. ~/.bash_prompt


export PATH=/usr/local/go/bin:/usr/local/bin/:$PATH
export GOPATH=~/Golang
export PATH=$GOPATH/bin:$PATH

# brew install exa
alias ls="exa"
alias ll="exa -l"
alias cat="ccat"
alias gst="git status"
alias gcb="git checkout -b "
alias gco="git checkout "

# git alias
alias gu='git add --all . && git commit -am "Update" && git push origin'
alias glf='git log --format="%H" -n 1 | pbcopy'

# util
alias weather='curl wttr.in'


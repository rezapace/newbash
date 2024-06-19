# ------------------------------
# Instant Prompt Initialization
# ------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ------------------------------
# Homebrew Initialization (macOS)
# ------------------------------
if command -v brew &>/dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ------------------------------
# Zinit Setup and Plugins
# ------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if not present
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname "$ZINIT_HOME")"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Load plugins asynchronously
zinit wait'!0' depth=1 for romkatv/powerlevel10k
zinit wait'!1' light zsh-users/zsh-syntax-highlighting
zinit wait'!2' light zsh-users/zsh-completions
zinit wait'!3' light zsh-users/zsh-autosuggestions
zinit wait'!4' light Aloxaf/fzf-tab
zinit wait'!5' light agkozak/zsh-z
zinit snippet OMZP::git OMZP::sudo OMZP::archlinux OMZP::aws OMZP::kubectl OMZP::kubectx OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

# Zinit completion replay
zinit cdreplay -q

# ------------------------------
# Powerlevel10k Configuration
# ------------------------------
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ------------------------------
# Keybindings
# ------------------------------
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey '^f' cdf

# ------------------------------
# History Settings
# ------------------------------
HISTSIZE=500000000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory sharehistory
setopt hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups

# ------------------------------
# Completion Styling
# ------------------------------
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ------------------------------
# Aliases
# ------------------------------
# General Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias rprofile='source ~/.zshrc'
alias profile='code ~/.zshrc'
alias closeall="$HOME/Documents/Backups/close_programs.sh"
alias g='cd $HOME/github'
alias home='cd $HOME'
alias lwifi='nmcli device wifi list'
alias cwifi="$HOME/Documents/Backups/cwifi.sh"
alias rwifi='sudo systemctl restart NetworkManager'
alias ofwifi='nmcli radio wifi off'
alias onwifi='nmcli radio wifi on'
alias e='caja .'
alias v='code .'
alias add='code $HOME/.local/share/applications/'
alias hapus='rm -rf'
alias mod='chmod +x ./'
alias scode='sudo code --no-sandbox --user-data-dir'
alias scursor='cd /opt && sudo -E ./cursor.appimage --no-sandbox'
alias addlink='cd $HOME/.local/share/applications && ./addlk.sh'
alias addfolder='cd $HOME/.local/share/applications && ./addfd.sh'
alias addconfig='cd $HOME/.local/share/applications && ./addsy.sh'
alias upprofile='cd $HOME/Documents/Backups && ./copy.sh'

# Chmod Aliases
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Docker Aliases
alias dstop='sudo systemctl stop docker.socket && sudo systemctl stop docker'
alias pstop='sudo systemctl stop podman && sudo systemctl stop podman.socket'
alias dstart='sudo systemctl start docker.socket && sudo systemctl start docker'
alias pstart='sudo systemctl start podman && sudo systemctl start podman.socket'
alias dstat='sudo systemctl status docker'
alias pstat='sudo systemctl status podman'

# XAMPP Aliases
alias ehtdoc='caja /var/www/html'
alias htdoc='cd /var/www/html'
alias www='cd /var/www/html'

# ------------------------------
# Functions
# ------------------------------
mkdirg() {
    mkdir -p "$1" && cd "$1"
}

gupp() {
    git add . && git commit -m "$1" && git push
}

xampprun() {
    sudo service httpd start && sudo service mariadb start
}

xamppstat() {
    sudo systemctl status httpd.service && sudo systemctl status mariadb.service
}

xamppstop() {
    sudo service httpd stop && sudo service mariadb stop
}

cpg() {
    local dest
    if [ -d "$2" ]; then
        dest="$2/$(basename "$1")"
        [ -e "$dest" ] && dest="${dest%.*}_$(date +"%Y%m%d%H%M%S").${dest##*.}"
        cp "$1" "$dest" && cd "$2"
    else
        cp "$1" "$2"
    fi
}

mvg() {
    local dest
    if [ -d "$2" ]; then
        dest="$2/$(basename "$1")"
        [ -e "$dest" ] && dest="${dest%.*}_$(date +"%Y%m%d%H%M%S").${dest##*.}"
        mv "$1" "$dest" && cd "$2"
    else
        mv "$1" "$2"
    fi
}

cpwd() {
    if [ -n "$1" ]; then
        cp -r "$PWD" "$1"
    else
        pwd | tr -d '\n' | xclip -selection clipboard
        echo "Current directory copied to clipboard."
    fi
}

# Directly open VS Code in directory
vs() {
    [ -n "$1" ] && z "$1" && code . || echo "Argument not provided"
}

# Directly open explorer in directory
ee() {
    [ -n "$1" ] && z "$1" && caja . || echo "Argument not provided"
}

# Open localhost web when coding
web() {
    local folderName="${PWD##*/}"
    local url="http://localhost/$folderName/"
    /usr/bin/google-chrome --new-tab "$url"
}

# Open localhost
local() {
    local url="http://localhost/phpmyadmin/"
    /usr/bin/google-chrome --new-tab "$url"
}

# Open GitHub profile
gr() {
    local url="https://github.com/rezapace?tab=repositories"
    /usr/bin/google-chrome --new-tab "$url"
}

# Generate new repo
gn() {
    local url="https://github.com/new"
    /usr/bin/google-chrome --new-tab "$url"
}

# Display phone screen
hp() {
    cd "$HOME/Documents/GitHub"
    ./scrcpy -m720 -b30m
}

# ------------------------------
# Shell Integrations
# ------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"

# Set Go environment
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Open cursor
cursor() {
    cd "$1" && /opt/cursor.appimage
}

# Function to search for a folder and cd into it
cdf() {
    local dir
    dir=$(find "${1:-.}" -type d 2>/dev/null | fzf --height 40% --layout=reverse --border)
    [ -n "$dir" ] && cd "$dir" && zle reset-prompt
}
zle -N cdf

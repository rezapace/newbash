if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]]; then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in zsh-z plugin
zinit light agkozak/zsh-z

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=500000000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias rprofile='source ~/.zshrc'
alias profile='code ~/.zshrc'
alias closeall='/home/r/Documents/Backups/close_programs.sh'
alias g='cd /home/r/github'
alias home='cd /home/r'
alias lwifi='nmcli device wifi list'
alias cwifi='/home/r/Documents/Backups/cwifi.sh'
alias e='caja .'
alias v='code .'
alias add='code /home/r/.local/share/applications/'
alias hapus='rm -rf'
alias mod='chmod +x ./'
alias scode='sudo code --no-sandbox --user-data-dir'
alias scursor='cd /opt && sudo -E ./cursor.appimage --no-sandbox'
alias addlink='cd /home/r/.local/share/applications && ./addlk.sh'
alias addfolder='cd /home/r/.local/share/applications && ./addfd.sh'
alias addconfig='cd /home/r/.local/share/applications && ./addsy.sh'
alias upprofile='cd /home/r/Documents/Backups && ./copy.sh'

#alias perintah
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# docker
alias dstop='sudo systemctl stop docker.socket && sudo systemctl stop docker'
alias pstop='sudo systemctl stop podman && sudo systemctl stop podman.socket'
alias dstart='sudo systemctl start docker.socket && sudo systemctl start docker'
alias pstart='sudo systemctl start podman && sudo systemctl start podman.socket'
alias dstat='sudo systemctl status docker'
alias pstat='sudo systemctl status socket'

# xampp
alias ehtdoc='caja /var/www/html'
alias htdoc='cd /var/www/html'
alias www='cd /var/www/html'

# Functions
mkdirg() {
    mkdir -p "$1"
    cd "$1"
}

gupp() {
    git add .
    git commit -m "$1"
    git push
}

xampprun() {
    sudo service httpd start
    sudo service mariadb start
}

xamppstat() {
    sudo systemctl status httpd.service
    sudo systemctl status mariadb.service
}

xamppstop() {
    sudo service httpd stop
    sudo service mariadb stop
}

cpg ()
{
    if [ -d "$2" ]; then
        dest="$2/$(basename "$1")"
        if [ -e "$dest" ]; then
            timestamp=$(date +"%Y%m%d%H%M%S")
            base="${dest%.*}"
            ext="${dest##*.}"
            if [ "$base" = "$ext" ]; then
                new_dest="${dest}_${timestamp}"
            else
                new_dest="${base}_${timestamp}.${ext}"
            fi
            cp "$1" "$new_dest"
        else
            cp "$1" "$dest"
        fi
        cd "$2"
    else
        cp "$1" "$2"
    fi
}

mvg ()
{
    if [ -d "$2" ]; then
        dest="$2/$(basename "$1")"
        if [ -e "$dest" ]; then
            timestamp=$(date +"%Y%m%d%H%M%S")
            base="${dest%.*}"
            ext="${dest##*.}"
            if [ "$base" = "$ext" ]; then
                new_dest="${dest}_${timestamp}"
            else
                new_dest="${base}_${timestamp}.${ext}"
            fi
            mv "$1" "$new_dest" && cd "$2"
        else
            mv "$1" "$dest" && cd "$2"
        fi
    else
        mv "$1" "$2"
    fi
}

cpwd() {
    if [ -n "$1" ]; then
        cp -r "$(pwd)" "$1"
    else
        pwd | tr -d '\n' | xclip -selection clipboard
        echo "Direktori saat ini telah disalin ke clipboard."
    fi
}

# langsung buka vscode di directory
function vs {
    if [ -n "$1" ]; then
        z "$1" && code .
    else
        echo "Argumen tidak diberikan"
    fi
}

# langsung buka explore di directory
function ee {
    if [ -n "$1" ]; then
        z "$1" && caja .
    else
        echo "Argumen tidak diberikan"
    fi
}

# membuka localhost web ketika ngoding (localhost/$folderName)
function web {
    folderName=$(basename $(pwd))
    url="http://localhost/$folderName/"
    /usr/bin/google-chrome --new-tab $url
}

# membuka localhost
function local {
    url="http://localhost/phpmyadmin/"
    /usr/bin/google-chrome --new-tab $url
}

# membuka github rezapace
function gr {
    url="https://github.com/rezapace?tab=repositories"
    /usr/bin/google-chrome --new-tab $url
}

# generate new repo
function gn {
    url="https://github.com/new"
    /usr/bin/google-chrome --new-tab $url
}


# menampilkan layar hp
function hp {
    cd $HOME/Documents/GitHub
    ./scrcpy -m720 -b30m
}

# Shell integrations
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"
# eval "$(zoxide init --cmd cd zsh)"

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

function cursor {
    cd "$1" && /opt/cursor.appimage
}

# Fungsi untuk mencari folder dan cd ke folder yang dipilih
cdf() {
    local dir
    dir=$(find ${1:-.} -type d 2> /dev/null | fzf --height 40% --layout=reverse --border)
    if [[ -n "$dir" ]]; then
        cd "$dir" && zle reset-prompt
    fi
}
zle -N cdf

# Keybinding untuk mencari folder dengan Ctrl + f
bindkey '^f' cdf



# debuging
# # Zsh Completion Styles
# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# zstyle ':completion:*' menu no

# # FZF-tab configurations
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
# zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# # Shell integrations
# echo "Loading fzf.zsh"
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# echo "Initializing fzf"
# eval "$(fzf --zsh)"

# echo "Initializing zoxide"
# eval "$(zoxide init --cmd cd zsh)"



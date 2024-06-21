# Initialize p10k instant prompt if cache file is readable
[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

# Set Zinit directory
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if not present
[[ ! -d "$ZINIT_HOME" ]] && { mkdir -p "$(dirname "$ZINIT_HOME")"; git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"; }

# Source Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Load plugins and themes with Zinit
plugins=(
  romkatv/powerlevel10k
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-completions
  zsh-users/zsh-autosuggestions
  marlonrichert/zsh-autocomplete
  rupa/z
  clvv/fasd
  wting/autojump
  trapd00r/LS_COLORS
  Aloxaf/fzf-tab
)

for plugin in "${plugins[@]}"; do
  zinit load "$plugin"
done

# Load snippets
snippets=(
  git sudo archlinux aws kubectl kubectx command-not-found
)

for snippet in "${snippets[@]}"; do
  zinit snippet OMZP::$snippet
done

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# Load Powerlevel10k configuration if it exists
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History configuration
HISTSIZE=500000000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select=2

# Fzf-tab configuration for Tab completion
zstyle ':fzf-tab:*' switch-group ','  # Use comma to switch groups in fzf-tab
zstyle ':fzf-tab:*' query-string ' '  # Start searching after pressing space
zstyle ':fzf-tab:*' fzf-preview 'bat --style=numbers --color=always --line-range :500 {}'  # Use bat for preview
zstyle ':fzf-tab:*' descriptions 'yes'
zstyle ':fzf-tab:*' disable-color 'no'
zstyle ':fzf-tab:*' complete-in 'yes'
zstyle ':fzf-tab:*' layout 'reverse'

# Optional: Fzf keybindings for interactive search
if [[ -n "$fzf_bindings" ]]; then
  source "$fzf_bindings"
fi

# Load LS_COLORS configuration
if [[ -f ~/.dircolors ]]; then
  eval "$(dircolors -b ~/.dircolors)"
fi

# Directory navigation aliases
alias www='cd /var/www/html'
alias g='cd ~/github'
alias home='cd ~'
alias h='cd ~'
alias htdoc='cd /var/www/html'

# Directory listing and management aliases
alias ls='exa --color=auto --group-directories-first'
alias ll='exa -alF --color=always --group-directories-first --icons'
alias tree='exa --tree --level=2 --color=always --group-directories-first --icons'

# File and directory permissions aliases
alias mod='chmod +x ./*'
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Network management aliases
alias stwifi='systemctl status NetworkManager'
alias startwifi='sudo systemctl start NetworkManager'
alias lwifi='nmcli device wifi list'
alias lswifi='nmcli device wifi rescan'
alias cwifi='~/Documents/Backups/cwifi.sh'
alias rwifi='sudo systemctl restart NetworkManager'
alias ofwifi='nmcli radio wifi off'
alias onwifi='nmcli radio wifi on'

# Docker and Podman management aliases
alias dstop='sudo systemctl stop docker.socket && sudo systemctl stop docker'
alias pstop='sudo systemctl stop podman && sudo systemctl stop podman.socket'
alias dstart='sudo systemctl start docker.socket && sudo systemctl start docker && log "Docker started" || log "Failed to start Docker"'
alias pstart='sudo systemctl start podman && sudo systemctl start podman.socket && log "Podman started" || log "Failed to start Podman"'
alias dstat='sudo systemctl status docker'
alias pstat='sudo systemctl status podman'

# Text editors and IDE aliases
alias vim='nvim'
alias v='code .'
alias add='code ~/.local/share/applications/'
alias profile='code ~/.zshrc'
alias scode='sudo code --no-sandbox --user-data-dir'

# Miscellaneous aliases
alias c='clear'
alias e='caja .'
alias ehtdoc='caja /var/www/html'
alias rprofile='source ~/.zshrc'
alias hapus='rm -rf'
alias scursor='cd /opt && sudo -E ./cursor.appimage --no-sandbox'
alias helpme='/home/r/Documents/Backups/helpme.sh'
alias upprofile='cd /home/r/Documents/Backups && ./copy.sh'
alias closeall='/home/r/Documents/Backups/close_programs.sh'
alias fzip='/home/r/Documents/Backups/fzip.sh'

# Functions
mkdirg() {
  [[ -n "$1" ]] && mkdir -p "$1" && cd "$1" || { echo "Usage: mkdirg <directory_name>"; return 1; }
}

gupp() {
  [[ -n "$1" ]] && git add . && git commit -m "$1" && git push || { echo "Usage: gupp <commit_message>"; return 1; }
}

xampp_control() {
  local action=$1
  local services=("apache2" "mysql")
  local action_capitalized=$(echo "${action:0:1}" | tr 'a-z' 'A-Z')${action:1}
  [[ -z "$action" ]] && { echo "Usage: xampp_control <start|stop|restart|status>"; return 1; }
  echo "${action_capitalized}ing XAMPP services..."
  for service in "${services[@]}"; do
    sudo service "$service" "$action" && log "XAMPP service $service ${action}ed" || log "Failed to ${action} XAMPP service $service"
  done
}

cpg() {
  local src=$1 dest=$2
  [[ -z "$src" || -z "$dest" ]] && { echo "Usage: cpg <source_file> <destination_directory>"; return 1; }
  local new_dest="$dest/$(basename "$src")"
  [[ -e "$new_dest" ]] && new_dest="${new_dest%.*}_$(date +"%Y%m%d%H%M%S").${new_dest##*.}"
  cp "$src" "$new_dest" && cd "$dest"
}

mvg() {
  local src=$1 dest=$2
  [[ -z "$src" || -z "$dest" ]] && { echo "Usage: mvg <source_file> <destination_directory>"; return 1; }
  local new_dest="$dest/$(basename "$src")"
  [[ -e "$new_dest" ]] && new_dest="${new_dest%.*}_$(date +"%Y%m%d%H%M%S").${new_dest##*.}"
  mv "$src" "$new_dest" && cd "$dest"
}

cpwd() {
  local dest=$1
  [[ -n "$dest" ]] && cp -r "$(pwd)" "$dest" || { pwd | tr -d '\n' | xclip -selection clipboard; echo "Current directory copied to clipboard."; }
}

swifi() {
  local SSID=$1 PASSWORD=$2
  [[ -z "$SSID" || -z "$PASSWORD" ]] && { echo "Usage: swifi <SSID> <PASSWORD>"; return 1; }
  nmcli device wifi connect "$SSID" password "$PASSWORD" && echo "Connected to $SSID successfully." || echo "Failed to connect to $SSID."
}

vs() {
  [[ -n "$1" ]] && z "$1" && code . || { echo "Usage: vs <directory>"; return 1; }
}

ee() {
  [[ -n "$1" ]] && z "$1" && caja . || { echo "Usage: ee <directory>"; return 1; }
}

web() {
  local folderName=$(basename "$(pwd)")
  local url="http://localhost/$folderName/"
  /usr/bin/google-chrome --new-tab "$url"
}

localhost() {
  local url="http://localhost/phpmyadmin/"
  /usr/bin/google-chrome --new-tab "$url"
}

grr() {
  local url="https://github.com/rezapace?tab=repositories"
  /usr/bin/google-chrome --new-tab "$url"
}

gn() {
  local url="https://github.com/new"
  /usr/bin/google-chrome --new-tab "$url"
}


hp() {
  cd "$HOME/Documents/GitHub" && ./scrcpy -m720 -b30m
}

cursor() {
  [[ -n "$1" ]] && cd "$1" && /opt/cursor.appimage || { echo "Usage: cursor <directory>"; return 1; }
}

cdf() {
  local dir=$(find ${1:-.} -type d 2> /dev/null | fzf --height 40% --layout=reverse --border)
  [[ -n "$dir" ]] && cd "$dir" && zle reset-prompt || { echo "No directory selected."; return 1; }
}
zle -N cdf
bindkey '^f' cdf

# Logging function
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> ~/.zsh_log
}

# zip unzip
extract() {
    if [[ $# -eq 0 ]]; then
        print_error "No file specified."
        return 1
    fi
    for file in "$@"; do
        if [[ -f $file ]]; then
            case $file in
                *.tar.gz) tar -xzf "$file" && print_success "Extracted $file" ;;
                *.zip) unzip "$file" && print_success "Extracted $file" ;;
                *.rar) unrar x "$file" && print_success "Extracted $file" ;;
                *) print_error "Unsupported file format: $file" ;;
            esac
        else
            print_error "File not found: $file"
        fi
    done
}

# Load fzf
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
eval "$(fzf --zsh)"

# Environment variables
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
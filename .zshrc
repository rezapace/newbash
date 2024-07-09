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
  # Aloxaf/fzf-tab
)

for plugin in "${plugins[@]}"; do
  zinit load "$plugin"
done

# Load snippets
snippets=(
  git
  sudo
  archlinux
  command-not-found
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
alias d='cd /home/r/Downloads'
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
alias rwifi='sudo systemctl restart NetworkManager'
alias ofwifi='nmcli radio wifi off'
alias onwifi='nmcli radio wifi on'
alias lwifi='nmcli device wifi list'
alias lswifi='nmcli device wifi rescan'
alias wifi='nmcli connection show --active'
alias gwifi='/home/r/Documents/Backups/wifi_connect.sh'

# Text editors and IDE aliases
alias vim='nvim'
alias v='code .'
alias add='code ~/.local/share/applications/'
alias profile='code ~/.zshrc'
alias scode='sudo code --no-sandbox --user-data-dir'

# Miscellaneous aliases
alias balena='cd /opt && ./balenaEtcher-1.19.21-x64.AppImage'
alias closefile='pkill caja'
alias c='clear'
alias e='caja .'
alias postgres='docker exec -it postgres psql -U postgres'
alias ehtdoc='caja /var/www/html'
alias rprofile='source ~/.zshrc'
alias hapus='rm -rf'
alias scursor='cd /opt && sudo -E ./cursor.appimage --no-sandbox'
alias obsidian='cd /opt && ./Obsidian-1.6.3.AppImage --no-sandbox'
alias helpme='/home/r/Documents/Backups/helpme.sh'
alias upprofile='cd /home/r/Documents/Backups && ./copy.sh'
alias closeall='/home/r/Documents/Backups/close_programs.sh'
alias fzip='/home/r/Documents/Backups/fzip.sh'
alias gnew='/home/r/Documents/Backups/gnew.sh'

#myscript
alias addlink='cd /home/r/.local/share/applications && ./addlk.sh'
alias addfolder='cd /home/r/.local/share/applications && ./addfd.sh'
alias addconfig='cd /home/r/.local/share/applications && ./addsy.sh'
alias bon='cd /home/r/Documents/Backups && ./connect_bluetooth.sh'
alias bof='cd /home/r/Documents/Backups && ./disconect_bluetooth.sh'

#docker
alias fzf-docker='/home/r/Documents/Backups/docker_fzf.sh'
alias fzf-preview='fzf --preview="batcat --color=always {}"'
alias docker-podman-fzf='/home/r/Documents/Backups/docker_podman_fzf.sh'
alias addsh='cd /home/r/Documents/Backups'
alias packages='/home/r/Documents/Backups/manage_package.sh'
alias files='/home/r/Documents/Backups/copy_move_file.sh'
alias task='/home/r/Documents/Backups/manage_runing.sh'
alias xampp='/home/r/Documents/Backups/xam.sh'


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

gweb() {
  local folderName=$(basename "$(pwd)")
  local url="http://github.com/rezapace/$folderName/"
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

cr() {
  local current_dir="$PWD"
  cd /opt
  sudo -E ./cursor.appimage --no-sandbox "$current_dir"
}


# cursor() {
#   [[ -n "$1" ]] && cd "$1" && /opt/cursor.appimage || { echo "Usage: cursor <directory>"; return 1; }
# }

cdf() {
  local dir=$(find ${1:-.} -type d 2> /dev/null | fzf --height 40% --layout=reverse --border)
  [[ -n "$dir" ]] && cd "$dir" && zle reset-prompt || { echo "No directory selected."; return 1; }
}
zle -N cdf
bindkey '^f' cdf

cdq() {
  cd /home/r && local dir=$(find "${1:-.}" -type d 2>/dev/null | fzf --height 40% --layout=reverse --border)
  [[ -n "$dir" ]] && cd "$dir" && zle reset-prompt || echo "No directory selected." && return 1
}
zle -N cdq
bindkey '^b' cdq

# Logging function
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> ~/.zsh_log
}

# zip unzip
extract() {
    [[ $# -eq 0 ]] && { print_error "No file specified."; return 1; }
    for file; do
        [[ -f $file ]] || { print_error "File not found: $file"; continue; }
        case $file in
            *.tar.gz) tar -xzf "$file" && print_success "Extracted $file" || print_error "Failed to extract $file" ;;
            *.zip) unzip "$file" && print_success "Extracted $file" || print_error "Failed to extract $file" ;;
            *.rar) unrar x "$file" && print_success "Extracted $file" || print_error "Failed to extract $file" ;;
            *) print_error "Unsupported file format: $file" ;;
        esac
    done
}

# Searches for text in all files in the current folder
ftext() {
	grep -iIHrn --color=always "$1" . | less -r
}

up() { [[ -z $1 || ! $1 =~ ^[0-9]+$ ]] && { print_error "Usage: up number_of_directories."; return 1; }; for ((i = 0; i < $1; i++)); do cd ..; done; }

function vv() {
  scursor "$1"
}


# # Fungsi untuk menampilkan fzf history search
# fzf_history_search() {
#   local selected
#   setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
#   selected=$(fc -rl 1 | awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' |
#     FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m --layout=reverse --preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'" fzf)
#   local ret=$?
#   if [ -n "$selected" ]; then
#     selected=$(echo "$selected" | sed 's/^[0-9 ]*//g')
#     zle reset-prompt
#     BUFFER="$selected"
#     zle accept-line
#   else
#     zle reset-prompt
#   fi
#   return $ret
# }


# zle     -N   fzf_history_search
# bindkey '^R' fzf_history_search

# # Fungsi untuk menampilkan fzf history search saat prompt kosong
# auto_fzf_history() {
#   if [[ ${#BUFFER} -eq 0 ]]; then
#     zle fzf_history_search
#   fi
# }

# # Buat widget dari fungsi auto_fzf_history
# zle -N auto_fzf_history

# # Tambahkan widget ke zle-line-init hook
# zle -N zle-line-init auto_fzf_history



# Load fzf
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
eval "$(fzf --zsh)"

# Environment variables
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
### README.md

# Konfigurasi Zsh dengan Zinit dan Plugin

Dokumentasi ini menjelaskan bagaimana cara mengonfigurasi shell Zsh dengan menggunakan Zinit untuk manajemen plugin, serta beberapa alias, fungsi, dan pengaturan tambahan untuk meningkatkan produktivitas.

## Daftar Isi

1. [Inisialisasi Prompt Instan](#inisialisasi-prompt-instan)
2. [Inisialisasi Homebrew](#inisialisasi-homebrew)
3. [Setup dan Plugin Zinit](#setup-dan-plugin-zinit)
4. [Konfigurasi Powerlevel10k](#konfigurasi-powerlevel10k)
5. [Pengaturan Keybindings](#pengaturan-keybindings)
6. [Pengaturan Riwayat](#pengaturan-riwayat)
7. [Penyelesaian Otomatis (Completion) Styling](#penyelesaian-otomatis-completion-styling)
8. [Alias](#alias)
9. [Fungsi](#fungsi)
10. [Integrasi Shell](#integrasi-shell)
11. [Pengaturan Lingkungan (Environment)](#pengaturan-lingkungan-environment)

## Inisialisasi Prompt Instan

Prompt instan digunakan untuk mempercepat tampilan prompt saat memulai Zsh.

```sh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
```

## Inisialisasi Homebrew

Homebrew diinisialisasi jika terdeteksi pada sistem.

```sh
if command -v brew &>/dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
```

## Setup dan Plugin Zinit

Menggunakan Zinit untuk mengelola plugin Zsh.

### Instalasi Zinit

Jika Zinit belum terinstal, script akan mengunduhnya terlebih dahulu.

```sh
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname "$ZINIT_HOME")"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
```

### Memuat Zinit dan Plugin

```sh
source "${ZINIT_HOME}/zinit.zsh"

# Plugin Zsh
zinit wait'!0' depth=1 for romkatv/powerlevel10k
zinit wait'!1' light zsh-users/zsh-syntax-highlighting
zinit wait'!2' light zsh-users/zsh-completions
zinit wait'!3' light zsh-users/zsh-autosuggestions
zinit wait'!4' light Aloxaf/fzf-tab
zinit wait'!5' light agkozak/zsh-z
zinit snippet OMZP::git OMZP::sudo OMZP::archlinux OMZP::aws OMZP::kubectl OMZP::kubectx OMZP::command-not-found

# Memuat penyelesaian otomatis
autoload -Uz compinit && compinit
zinit cdreplay -q
```

## Konfigurasi Powerlevel10k

Memuat konfigurasi Powerlevel10k jika ada.

```sh
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
```

## Pengaturan Keybindings

Mengatur keybindings untuk Zsh.

```sh
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey '^f' cdf
```

## Pengaturan Riwayat

Mengonfigurasi pengaturan riwayat.

```sh
HISTSIZE=500000000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory sharehistory
setopt hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups
```

## Penyelesaian Otomatis (Completion) Styling

Menyesuaikan penyelesaian otomatis (completion) agar lebih nyaman digunakan.

```sh
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
```

## Alias

Mengatur berbagai alias untuk mempercepat perintah sehari-hari.

### Alias Umum

```sh
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
```

### Alias Chmod

```sh
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'
```

### Alias Docker

```sh
alias dstop='sudo systemctl stop docker.socket && sudo systemctl stop docker'
alias pstop='sudo systemctl stop podman && sudo systemctl stop podman.socket'
alias dstart='sudo systemctl start docker.socket && sudo systemctl start docker'
alias pstart='sudo systemctl start podman && sudo systemctl start podman.socket'
alias dstat='sudo systemctl status docker'
alias pstat='sudo systemctl status podman'
```

### Alias XAMPP

```sh
alias ehtdoc='caja /var/www/html'
alias htdoc='cd /var/www/html'
alias www='cd /var/www/html'
```

## Fungsi

### Membuat dan Berpindah ke Direktori

```sh
mkdirg() {
    mkdir -p "$1" && cd "$1"
}
```

### Mengupdate Repositori Git

```sh
gupp() {
    git add . && git commit -m "$1" && git push
}
```

### Menjalankan XAMPP

```sh
xampprun() {
    sudo service httpd start && sudo service mariadb start
}
```

### Memeriksa Status XAMPP

```sh
xamppstat() {
    sudo systemctl status httpd.service && sudo systemctl status mariadb.service
}
```

### Menghentikan XAMPP

```sh
xamppstop() {
    sudo service httpd stop && sudo service mariadb stop
}
```

### Menyalin dan Berpindah Direktori

```sh
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
```

### Memindahkan dan Berpindah Direktori

```sh
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
```

### Menyalin Direktori Saat Ini ke Clipboard

```sh
cpwd() {
    if [ -n "$1" ]; then
        cp -r "$PWD" "$1"
    else
        pwd | tr -d '\n' | xclip -selection clipboard
        echo "Current directory copied to clipboard."
    fi
}
```

### Membuka VS Code di Direktori Tertentu

```sh
vs() {
    [ -n "$1" ] && z "$1" && code . || echo "Argument not provided"
}
```

### Membuka Explorer di Direktori Tertentu



```sh
ee() {
    [ -n "$1" ] && z "$1" && caja . || echo "Argument not provided"
}
```

### Membuka Web Lokal Saat Coding

```sh
web() {
    local folderName="${PWD##*/}"
    local url="http://localhost/$folderName/"
    /usr/bin/google-chrome --new-tab "$url"
}
```

### Membuka phpMyAdmin Lokal

```sh
local() {
    local url="http://localhost/phpmyadmin/"
    /usr/bin/google-chrome --new-tab "$url"
}
```

### Membuka Profil GitHub

```sh
gr() {
    local url="https://github.com/rezapace?tab=repositories"
    /usr/bin/google-chrome --new-tab "$url"
}
```

### Membuat Repositori Baru

```sh
gn() {
    local url="https://github.com/new"
    /usr/bin/google-chrome --new-tab "$url"
}
```

### Menampilkan Layar Ponsel

```sh
hp() {
    cd "$HOME/Documents/GitHub"
    ./scrcpy -m720 -b30m
}
```

## Integrasi Shell

Mengintegrasikan fzf dan pengaturan lingkungan.

```sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"
```

## Pengaturan Lingkungan (Environment)

Mengatur variabel lingkungan untuk Go.

```sh
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
```

### Membuka Aplikasi Cursor

```sh
cursor() {
    cd "$1" && /opt/cursor.appimage
}
```

### Fungsi untuk Mencari dan Berpindah ke Direktori

```sh
cdf() {
    local dir
    dir=$(find "${1:-.}" -type d 2>/dev/null | fzf --height 40% --layout=reverse --border)
    [ -n "$dir" ] && cd "$dir" && zle reset-prompt
}
zle -N cdf
```

Dokumentasi ini memberikan panduan lengkap untuk mengonfigurasi Zsh dengan berbagai plugin dan pengaturan untuk meningkatkan efisiensi dan produktivitas kerja.
#!/bin/bash
iatest=$(expr index "$-" i)

#######################################################
# SOURCED ALIAS'S AND SCRIPTS BY zachbrowne.me
#######################################################
if [ -f /usr/bin/fastfetch ]; then
	fastfetch
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

#######################################################
# EXPORTS
#######################################################

# Disable the bell
if [[ $iatest -gt 0 ]]; then bind "set bell-style visible"; fi

# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=500

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
PROMPT_COMMAND='history -a'

# Allow ctrl-S for history navigation (with ctrl-R)
[[ $- == *i* ]] && stty -ixon

# Ignore case on auto-completion
# Note: bind used instead of sticking these in .inputrc
if [[ $iatest -gt 0 ]]; then bind "set completion-ignore-case on"; fi

# Show auto-completion list automatically, without double tab
if [[ $iatest -gt 0 ]]; then bind "set show-all-if-ambiguous On"; fi

# Set the default editor
export EDITOR=nvim
export VISUAL=nvim
alias pico='edit'
alias spico='sedit'
alias nano='edit'
alias snano='sedit'
alias vim='nvim'

# Replace batcat with cat on Fedora as batcat is not available as a RPM in any form
if command -v lsb_release >/dev/null; then
	DISTRIBUTION=$(lsb_release -si)

	if [ "$DISTRIBUTION" = "Fedora" ] || [ "$DISTRIBUTION" = "Arch" ]; then
		alias cat='bat'
	else
		alias cat='batcat'
	fi
fi

# To have colors for ls and all grep commands such as grep, egrep and zgrep
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'
#export GREP_OPTIONS='--color=auto' #deprecated
alias grep="/usr/bin/grep $GREP_OPTIONS"
unset GREP_OPTIONS

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#######################################################
# MACHINE SPECIFIC ALIAS'S
#######################################################

# Alias's for SSH
# alias SERVERNAME='ssh YOURWEBSITE.com -l USERNAME -p PORTNUMBERHERE'

# Alias's to change the directory
alias web='cd /var/www/html'

# Alias's to mount ISO files
# mount -o loop /home/NAMEOFISO.iso /home/ISOMOUNTDIR/
# umount /home/NAMEOFISO.iso
# (Both commands done as root only.)

#######################################################
# GENERAL ALIAS'S
#######################################################
# To temporarily bypass an alias, we precede the command with a \
# EG: the ls command is aliased, but to use the normal ls command you would type \ls

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Edit this .bashrc file
alias ebrc='edit ~/.bashrc'

# Show help for this .bashrc file
alias hlp='less ~/.bashrc_help'

# alias to show the date
alias da='date "+%Y-%m-%d %A %T %Z"'

# Alias's to modified commands
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias cls='clear'
alias apt-get='sudo apt-get'
alias multitail='multitail --no-repeat -c'
alias freshclam='sudo freshclam'
alias vi='nvim'
alias svi='sudo vi'
alias vis='nvim "+set si"'

# Change directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# cd into the old directory
alias bd='cd "$OLDPWD"'

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# Alias's for multiple directory listing commands
alias la='ls -Alh'                # show hidden files
alias ls='ls -aFh --color=always' # add colors and file type extensions
alias lx='ls -lXBh'               # sort by extension
alias lk='ls -lSrh'               # sort by size
alias lc='ls -lcrh'               # sort by change time
alias lu='ls -lurh'               # sort by access time
alias lr='ls -lRh'                # recursive ls
alias lt='ls -ltrh'               # sort by date
alias lm='ls -alh |more'          # pipe through 'more'
alias lw='ls -xAh'                # wide listing format
alias ll='ls -Fls'                # long listing format
alias labc='ls -lap'              #alphabetical sort
alias lf="ls -l | egrep -v '^d'"  # files only
alias ldir="ls -l | egrep '^d'"   # directories only

# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Search command line history
alias h="history | grep "

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Search files in the current folder
alias f="find . | grep "

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# To see if a command is aliased, a file, or a built-in command
alias checkcommand="type -t"

# Show open ports
alias openports='netstat -nape --inet'

# Alias's for safe and forced reboots
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

# Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# SHA1
alias sha1='openssl sha1'

alias clickpaste='sleep 3; xdotool type "$(xclip -o -selection clipboard)"'

# KITTY - alias to be able to use kitty features when connecting to remote servers(e.g use tmux on remote server)

alias kssh="kitty +kitten ssh"

#######################################################
# SPECIAL FUNCTIONS
#######################################################
# Extracts any archive(s) (if unp isn't installed)
extract() {
	for archive in "$@"; do
		if [ -f "$archive" ]; then
			case $archive in
			*.tar.bz2) tar xvjf $archive ;;
			*.tar.gz) tar xvzf $archive ;;
			*.bz2) bunzip2 $archive ;;
			*.rar) rar x $archive ;;
			*.gz) gunzip $archive ;;
			*.tar) tar xvf $archive ;;
			*.tbz2) tar xvjf $archive ;;
			*.tgz) tar xvzf $archive ;;
			*.zip) unzip $archive ;;
			*.Z) uncompress $archive ;;
			*.7z) 7z x $archive ;;
			*) echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# Searches for text in all files in the current folder
ftext() {
	# -i case-insensitive
	# -I ignore binary files
	# -H causes filename to be printed
	# -r recursive search
	# -n causes line number to be printed
	# optional: -F treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iIHrn --color=always "$1" . | less -r
}

# Copy file with a progress bar
cpp() {
	set -e
	strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
		awk '{
	count += $NF
	if (count % 10 == 0) {
		percent = count / total_size * 100
		printf "%3d%% [", percent
		for (i=0;i<=percent;i++)
			printf "="
			printf ">"
			for (i=percent;i<100;i++)
				printf " "
				printf "]\r"
			}
		}
	END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# Copy and go to the directory
cpg() {
	if [ -d "$2" ]; then
		cp "$1" "$2" && cd "$2"
	else
		cp "$1" "$2"
	fi
}

# Move and go to the directory
mvg() {
	if [ -d "$2" ]; then
		mv "$1" "$2" && cd "$2"
	else
		mv "$1" "$2"
	fi
}

# Create and go to the directory
mkdirg() {
	mkdir -p "$1"
	cd "$1"
}

# Goes up a specified number of directories  (i.e. up 4)
up() {
	local d=""
	limit=$1
	for ((i = 1; i <= limit; i++)); do
		d=$d/..
	done
	d=$(echo $d | sed 's/^\///')
	if [ -z "$d" ]; then
		d=..
	fi
	cd $d
}

# Automatically do an ls after each cd, z, or zoxide
cd ()
{
	if [ -n "$1" ]; then
		builtin cd "$@" && ls
	else
		builtin cd ~ && ls
	fi
}

# Returns the last 2 fields of the working directory
pwdtail() {
	pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

# Show the current distribution
distribution ()
{
	local dtype="unknown"  # Default to unknown

	# Use /etc/os-release for modern distro identification
	if [ -r /etc/os-release ]; then
		source /etc/os-release
		case $ID in
			fedora|rhel|centos)
				dtype="redhat"
				;;
			sles|opensuse*)
				dtype="suse"
				;;
			ubuntu|debian)
				dtype="debian"
				;;
			gentoo)
				dtype="gentoo"
				;;
			arch)
				dtype="arch"
				;;
			slackware)
				dtype="slackware"
				;;
			*)
				# If ID is not recognized, keep dtype as unknown
				;;
		esac
	fi

	echo $dtype
}

# Show the current version of the operating system
ver() {
	local dtype
	dtype=$(distribution)

	case $dtype in
		"redhat")
			if [ -s /etc/redhat-release ]; then
				cat /etc/redhat-release
			else
				cat /etc/issue
			fi
			uname -a
			;;
		"suse")
			cat /etc/SuSE-release
			;;
		"debian")
			lsb_release -a
			;;
		"gentoo")
			cat /etc/gentoo-release
			;;
		"arch")
			cat /etc/os-release
			;;
		"slackware")
			cat /etc/slackware-version
			;;
		*)
			if [ -s /etc/issue ]; then
				cat /etc/issue
			else
				echo "Error: Unknown distribution"
				exit 1
			fi
			;;
	esac
}

# Automatically install the needed support files for this .bashrc file
install_bashrc_support() {
	local dtype
	dtype=$(distribution)

	case $dtype in
		"redhat")
			sudo yum install multitail tree zoxide trash-cli fzf bash-completion fastfetch
			;;
		"suse")
			sudo zypper install multitail tree zoxide trash-cli fzf bash-completion fastfetch
			;;
		"debian")
			sudo apt-get install multitail tree zoxide trash-cli fzf bash-completion
			# Fetch the latest fastfetch release URL for linux-amd64 deb file
			FASTFETCH_URL=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | grep "browser_download_url.*linux-amd64.deb" | cut -d '"' -f 4)
			
			# Download the latest fastfetch deb file
			curl -sL $FASTFETCH_URL -o /tmp/fastfetch_latest_amd64.deb
			
			# Install the downloaded deb file using apt-get
			sudo apt-get install /tmp/fastfetch_latest_amd64.deb
			;;
		"arch")
			sudo paru multitail tree zoxide trash-cli fzf bash-completion fastfetch
			;;
		"slackware")
			echo "No install support for Slackware"
			;;
		*)
			echo "Unknown distribution"
			;;
	esac
}

# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip ()
{
	# Internal IP Lookup.
	if [ -e /sbin/ip ]; then
		echo -n "Internal IP: "
		/sbin/ip addr show wlan0 | grep "inet " | awk -F: '{print $1}' | awk '{print $2}'
	else
		echo -n "Internal IP: "
		/sbin/ifconfig wlan0 | grep "inet " | awk -F: '{print $1} |' | awk '{print $2}'
	fi

	# External IP Lookup
	echo -n "External IP: "
	curl -s ifconfig.me
}

# View Apache logs
apachelog() {
	if [ -f /etc/httpd/conf/httpd.conf ]; then
		cd /var/log/httpd && ls -xAh && multitail --no-repeat -c -s 2 /var/log/httpd/*_log
	else
		cd /var/log/apache2 && ls -xAh && multitail --no-repeat -c -s 2 /var/log/apache2/*.log
	fi
}

# Edit the Apache configuration
apacheconfig() {
	if [ -f /etc/httpd/conf/httpd.conf ]; then
		sedit /etc/httpd/conf/httpd.conf
	elif [ -f /etc/apache2/apache2.conf ]; then
		sedit /etc/apache2/apache2.conf
	else
		echo "Error: Apache config file could not be found."
		echo "Searching for possible locations:"
		sudo updatedb && locate httpd.conf && locate apache2.conf
	fi
}

# Edit the PHP configuration file
phpconfig() {
	if [ -f /etc/php.ini ]; then
		sedit /etc/php.ini
	elif [ -f /etc/php/php.ini ]; then
		sedit /etc/php/php.ini
	elif [ -f /etc/php5/php.ini ]; then
		sedit /etc/php5/php.ini
	elif [ -f /usr/bin/php5/bin/php.ini ]; then
		sedit /usr/bin/php5/bin/php.ini
	elif [ -f /etc/php5/apache2/php.ini ]; then
		sedit /etc/php5/apache2/php.ini
	else
		echo "Error: php.ini file could not be found."
		echo "Searching for possible locations:"
		sudo updatedb && locate php.ini
	fi
}

# Edit the MySQL configuration file
mysqlconfig() {
	if [ -f /etc/my.cnf ]; then
		sedit /etc/my.cnf
	elif [ -f /etc/mysql/my.cnf ]; then
		sedit /etc/mysql/my.cnf
	elif [ -f /usr/local/etc/my.cnf ]; then
		sedit /usr/local/etc/my.cnf
	elif [ -f /usr/bin/mysql/my.cnf ]; then
		sedit /usr/bin/mysql/my.cnf
	elif [ -f ~/my.cnf ]; then
		sedit ~/my.cnf
	elif [ -f ~/.my.cnf ]; then
		sedit ~/.my.cnf
	else
		echo "Error: my.cnf file could not be found."
		echo "Searching for possible locations:"
		sudo updatedb && locate my.cnf
	fi
}


# Trim leading and trailing spaces (for scripts)
trim() {
	local var=$*
	var="${var#"${var%%[![:space:]]*}"}" # remove leading whitespace characters
	var="${var%"${var##*[![:space:]]}"}" # remove trailing whitespace characters
	echo -n "$var"
}
# GitHub Titus Additions

gcom() {
	git add .
	git commit -m "$1"
}
lazyg() {
	git add .
	git commit -m "$1"
	git push
}

function hb {
    if [ $# -eq 0 ]; then
        echo "No file path specified."
        return
    elif [ ! -f "$1" ]; then
        echo "File path does not exist."
        return
    fi

    uri="http://bin.christitus.com/documents"
    response=$(curl -s -X POST -d "$(cat "$1")" "$uri")
    if [ $? -eq 0 ]; then
        hasteKey=$(echo $response | jq -r '.key')
        echo "http://bin.christitus.com/$hasteKey"
    else
        echo "Failed to upload the document."
    fi
}

#######################################################
# Set the ultimate amazing command prompt
#######################################################

alias hug="hugo server -F --bind=10.0.0.97 --baseURL=http://10.0.0.97"
bind '"\C-f":"zi\n"'

export PATH=$PATH:"$HOME/.local/bin:$HOME/.cargo/bin:/var/lib/flatpak/exports/bin:/.local/share/flatpak/exports/bin"

# Install Starship - curl -sS https://starship.rs/install.sh | sh
eval "$(starship init bash)"
eval "$(zoxide init bash)"


Berikut adalah fungsi-fungsi yang ada di dalam script bashrc yang kamu berikan, beserta penjelasan dan cara penggunaannya:

1. **extract**
   - **Deskripsi**: Mengekstrak berbagai jenis arsip (zip, tar.gz, rar, dll).
   - **Cara Menggunakan**: `extract file1.tar.gz file2.zip`

2. **ftext**
   - **Deskripsi**: Mencari teks dalam semua file di folder saat ini.
   - **Cara Menggunakan**: `ftext "cari_teks"`

3. **cpp**
   - **Deskripsi**: Menyalin file dengan progress bar.
   - **Cara Menggunakan**: `cpp sumber tujuan`

4. **cpg**
   - **Deskripsi**: Menyalin file dan berpindah ke direktori tujuan.
   - **Cara Menggunakan**: `cpg file /direktori_tujuan`

5. **mvg**
   - **Deskripsi**: Memindahkan file dan berpindah ke direktori tujuan.
   - **Cara Menggunakan**: `mvg file /direktori_tujuan`

6. **mkdirg**
   - **Deskripsi**: Membuat dan berpindah ke direktori baru.
   - **Cara Menggunakan**: `mkdirg direktori_baru`

7. **up**
   - **Deskripsi**: Berpindah ke sejumlah direktori di atas direktori saat ini.
   - **Cara Menggunakan**: `up 3` (untuk berpindah ke 3 direktori di atas)

8. **pwdtail**
   - **Deskripsi**: Menampilkan dua bagian terakhir dari path direktori saat ini.
   - **Cara Menggunakan**: `pwdtail`

9. **distribution**
   - **Deskripsi**: Menampilkan distribusi Linux saat ini.
   - **Cara Menggunakan**: `distribution`

10. **ver**
    - **Deskripsi**: Menampilkan versi dari sistem operasi.
    - **Cara Menggunakan**: `ver`

11. **install_bashrc_support**
    - **Deskripsi**: Menginstal paket-paket yang diperlukan untuk mendukung script .bashrc ini.
    - **Cara Menggunakan**: `install_bashrc_support`

12. **whatsmyip**
    - **Deskripsi**: Menampilkan IP internal dan eksternal.
    - **Cara Menggunakan**: `whatsmyip`

13. **apachelog**
    - **Deskripsi**: Menampilkan log Apache.
    - **Cara Menggunakan**: `apachelog`

14. **apacheconfig**
    - **Deskripsi**: Mengedit konfigurasi Apache.
    - **Cara Menggunakan**: `apacheconfig`

15. **phpconfig**
    - **Deskripsi**: Mengedit konfigurasi PHP.
    - **Cara Menggunakan**: `phpconfig`

16. **mysqlconfig**
    - **Deskripsi**: Mengedit konfigurasi MySQL.
    - **Cara Menggunakan**: `mysqlconfig`

17. **trim**
    - **Deskripsi**: Menghilangkan spasi di awal dan akhir string.
    - **Cara Menggunakan**: `trim "  teks dengan spasi  "`

18. **gcom**
    - **Deskripsi**: Menambah dan meng-commit semua perubahan dengan pesan commit yang diberikan.
    - **Cara Menggunakan**: `gcom "pesan commit"`

19. **lazyg**
    - **Deskripsi**: Menambah, meng-commit, dan mendorong semua perubahan dengan pesan commit yang diberikan.
    - **Cara Menggunakan**: `lazyg "pesan commit"`

20. **hb**
    - **Deskripsi**: Mengunggah file teks ke hastebin dan mengembalikan URL.
    - **Cara Menggunakan**: `hb path/to/file`

Setiap fungsi memiliki tujuan spesifik dan cara penggunaan yang telah dijelaskan di atas. Kamu dapat menambahkan atau mengubah sesuai kebutuhan kamu dengan mengedit script .bashrc tersebut.


# script for zsh
#!/bin/zsh

# Warna untuk output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_error() {
    echo -e "${RED}Error:${NC} $1"
}

extract() {
    if [[ $# -eq 0 ]]; then
        print_error "No file specified."
        return 1
    fi
    for file in "$@"; do
        if [[ -f $file ]]; then
            case $file in
                *.tar.gz) tar -xzf "$file" ;;
                *.zip) unzip "$file" ;;
                *.rar) unrar x "$file" ;;
                *) print_error "Unsupported file format: $file" ;;
            esac
        else
            print_error "File not found: $file"
        fi
    done
}

ftext() {
    if [[ -z $1 ]]; then
        print_error "No text specified."
        return 1
    fi
    grep -r "$1" . || print_error "Text not found."
}

cpp() {
    if [[ $# -ne 2 ]]; then
        print_error "Usage: cpp source destination."
        return 1
    fi
    rsync --progress "$1" "$2"
}

cpg() {
    if [[ $# -ne 2 ]]; then
        print_error "Usage: cpg file /destination_directory."
        return 1
    fi
    cp "$1" "$2" && cd "$2"
}

mvg() {
    if [[ $# -ne 2 ]]; then
        print_error "Usage: mvg file /destination_directory."
        return 1
    fi
    mv "$1" "$2" && cd "$2"
}

mkdirg() {
    if [[ -z $1 ]]; then
        print_error "No directory name specified."
        return 1
    fi
    mkdir -p "$1" && cd "$1"
}

up() {
    if [[ -z $1 || ! $1 =~ '^[0-9]+$' ]]; then
        print_error "Usage: up number_of_directories."
        return 1
    fi
    for ((i = 0; i < $1; i++)); do
        cd ..
    done
}

pwdtail() {
    echo "${PWD##*/}/${PWD##*/}"
}

distribution() {
    lsb_release -a 2>/dev/null || cat /etc/*release 2>/dev/null
}

ver() {
    uname -a
}

install_bashrc_support() {
    echo -e "${GREEN}Installing necessary packages...${NC}"
    sudo apt-get update
    sudo apt-get install -y unzip unrar rsync
}

whatsmyip() {
    echo -e "${YELLOW}Internal IP:${NC} $(hostname -I | awk '{print $1}')"
    echo -e "${YELLOW}External IP:${NC} $(curl -s ifconfig.me)"
}

apachelog() {
    tail -f /var/log/apache2/access.log
}

apacheconfig() {
    sudo nano /etc/apache2/apache2.conf
}

phpconfig() {
    sudo nano /etc/php/7.4/apache2/php.ini
}

mysqlconfig() {
    sudo nano /etc/mysql/my.cnf
}

trim() {
    if [[ -z $1 ]]; then
        print_error "No text specified."
        return 1
    fi
    echo "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

gcom() {
    if [[ -z $1 ]]; then
        print_error "No commit message specified."
        return 1
    fi
    git add . && git commit -m "$1"
}

lazyg() {
    if [[ -z $1 ]]; then
        print_error "No commit message specified."
        return 1
    fi
    git add . && git commit -m "$1" && git push
}

hb() {
    if [[ -z $1 ]]; then
        print_error "No file path specified."
        return 1
    fi
    cat "$1" | hastebin
}


# penggunaan 
Berikut adalah deskripsi dan cara penggunaan untuk setiap fungsi dalam skrip Zsh:

### `extract`
**Deskripsi**: Mengekstrak berbagai jenis arsip (zip, tar.gz, rar, dll).

**Cara Menggunakan**: 
```sh
extract file1.tar.gz file2.zip
```

### `ftext`
**Deskripsi**: Mencari teks dalam semua file di folder saat ini.

**Cara Menggunakan**: 
```sh
ftext "cari_teks"
```

### `cpp`
**Deskripsi**: Menyalin file dengan progress bar.

**Cara Menggunakan**: 
```sh
cpp sumber tujuan
```

### `cpg`
**Deskripsi**: Menyalin file dan berpindah ke direktori tujuan.

**Cara Menggunakan**: 
```sh
cpg file /direktori_tujuan
```

### `mvg`
**Deskripsi**: Memindahkan file dan berpindah ke direktori tujuan.

**Cara Menggunakan**: 
```sh
mvg file /direktori_tujuan
```

### `mkdirg`
**Deskripsi**: Membuat dan berpindah ke direktori baru.

**Cara Menggunakan**: 
```sh
mkdirg direktori_baru
```

### `up`
**Deskripsi**: Berpindah ke sejumlah direktori di atas direktori saat ini.

**Cara Menggunakan**: 
```sh
up 3
```
(untuk berpindah ke 3 direktori di atas)

### `pwdtail`
**Deskripsi**: Menampilkan dua bagian terakhir dari path direktori saat ini.

**Cara Menggunakan**: 
```sh
pwdtail
```

### `distribution`
**Deskripsi**: Menampilkan distribusi Linux saat ini.

**Cara Menggunakan**: 
```sh
distribution
```

### `ver`
**Deskripsi**: Menampilkan versi dari sistem operasi.

**Cara Menggunakan**: 
```sh
ver
```

### `install_bashrc_support`
**Deskripsi**: Menginstal paket-paket yang diperlukan untuk mendukung script .bashrc ini.

**Cara Menggunakan**: 
```sh
install_bashrc_support
```

### `whatsmyip`
**Deskripsi**: Menampilkan IP internal dan eksternal.

**Cara Menggunakan**: 
```sh
whatsmyip
```

### `apachelog`
**Deskripsi**: Menampilkan log Apache.

**Cara Menggunakan**: 
```sh
apachelog
```

### `apacheconfig`
**Deskripsi**: Mengedit konfigurasi Apache.

**Cara Menggunakan**: 
```sh
apacheconfig
```

### `phpconfig`
**Deskripsi**: Mengedit konfigurasi PHP.

**Cara Menggunakan**: 
```sh
phpconfig
```

### `mysqlconfig`
**Deskripsi**: Mengedit konfigurasi MySQL.

**Cara Menggunakan**: 
```sh
mysqlconfig
```

### `trim`
**Deskripsi**: Menghilangkan spasi di awal dan akhir string.

**Cara Menggunakan**: 
```sh
trim " teks dengan spasi "
```

### `gcom`
**Deskripsi**: Menambah dan meng-commit semua perubahan dengan pesan commit yang diberikan.

**Cara Menggunakan**: 
```sh
gcom "pesan commit"
```

### `lazyg`
**Deskripsi**: Menambah, meng-commit, dan mendorong semua perubahan dengan pesan commit yang diberikan.

**Cara Menggunakan**: 
```sh
lazyg "pesan commit"
```

### `hb`
**Deskripsi**: Mengunggah file teks ke hastebin dan mengembalikan URL.

**Cara Menggunakan**: 
```sh
hb path/to/file
```

Dengan menggunakan deskripsi dan cara penggunaan ini, Anda dapat dengan mudah memahami dan menggunakan setiap fungsi dalam skrip Zsh yang telah disediakan.
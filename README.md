# README for Proyek Baru

## Overview
This project involves managing various application shortcuts and configurations primarily for a Linux environment. It includes scripts for creating [.desktop](file:///home/r/github/newbash/applications/folder/lsp.desktop#1%2C1-1%2C1) entries for applications, managing system configurations, and handling application processes.

## Directory Structure
- [applications/](file:///home/r/github/newbash/applications/addfd.sh#11%2C52-11%2C52): Contains [.desktop](file:///home/r/github/newbash/applications/folder/lsp.desktop#1%2C1-1%2C1) files for various applications and folders.
- `applications/app chrome/`: `.desktop` entries for web applications opened via Google Chrome.
- `applications/app system/`: `.desktop` entries for system applications and configurations.
- `applications/folder/`: `.desktop` entries for folder shortcuts.

## Key Scripts
- `addfd.sh`: Script to create a `.desktop` file for a new application in a specific folder.
- `addsy.sh`: Script to create a `.desktop` file for system configurations.
- `addlk.sh`: Script to create a `.desktop` file for web links using Google Chrome.
- `close_programs.sh`: Script to close a predefined list of applications.

## Usage
To create a new application shortcut:
```shell
./addfd.sh
```
To add a new system configuration shortcut:
```shell
./addsy.sh
```
To generate a new link shortcut:
```shell
./addlk.sh
```
To close all predefined applications:
```shell
./close_programs.sh
```

## Configuration Files
- `.zshrc`: Contains aliases and functions for various tasks including opening applications, managing configurations, and custom commands for Docker, XAMPP, and more.

## Important Paths
- Application shortcuts: `/home/r/.local/share/applications/`
- ZSH configuration: `/home/r/.zshrc`
- Bash configuration: `/home/r/.bashrc`
- Bash profile: `/home/r/.bash_profile`

For more detailed usage and additional configurations, refer to the `.zshrc` file and individual scripts within the `applications/` directory.

for start function
chmod +x "/home/r/.local/share/applications/app system/hibernate.desktop"

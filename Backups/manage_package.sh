#!/bin/zsh

# Function to display package management menu and select action
package_menu() {
    echo -e "1. Install Package\n2. Remove Package\n3. Update Package List\n4. Upgrade Packages\n5. Exit" | fzf --prompt="Select Package Action: " --height=20% --border
}

# Function to install a package
install_package() {
    local package=$(apt-cache search . | awk '{print $1}' | fzf --prompt="Select Package to Install: " --height=40% --layout=reverse --border)
    if [[ -n "$package" ]]; then
        sudo apt-get install "$package"
    else
        echo "No package selected. Returning to package management menu."
    fi
}

# Function to remove a package
remove_package() {
    local package=$(dpkg --get-selections | awk '{print $1}' | fzf --prompt="Select Package to Remove: " --height=40% --layout=reverse --border)
    if [[ -n "$package" ]]; then
        sudo apt-get remove "$package"
    else
        echo "No package selected. Returning to package management menu."
    fi
}

# Function to update package list
update_package_list() {
    sudo apt-get update
    echo "Package list updated."
}

# Function to upgrade packages
upgrade_packages() {
    sudo apt-get upgrade
    echo "Packages upgraded."
}

# Main script logic
while true; do
    action=$(package_menu)

    case "$action" in
        "1. Install Package")
            install_package
            ;;
        "2. Remove Package")
            remove_package
            ;;
        "3. Update Package List")
            update_package_list
            ;;
        "4. Upgrade Packages")
            upgrade_packages
            ;;
        "5. Exit")
            echo "Exiting program."
            exit 0
            ;;
        *)
            echo "Invalid action selected. Returning to package management menu."
            ;;
    esac
done

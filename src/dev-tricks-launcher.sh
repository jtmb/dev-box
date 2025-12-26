#!/bin/bash

# Function to display ASCII art
display_ascii_art() {
cat << "EOF"
 ____  _______     __  _____ ____  ___ ____ _  ______  
|  _ \| ____\ \   / / |_   _|  _ \|_ _/ ___| |/ / ___| 
| | | |  _|  \ \ / /    | | | |_) || | |   | ' /\___ \ 
| |_| | |___  \ V /     | | |  _ < | | |___| . \ ___) |
|____/|_____|  \_/      |_| |_| \_\___\____|_|\_\____/ 
https://github.com/jtmb
EOF
echo
}

# Pause helper function
pause() {
    echo
    read -rp "Press Enter to return to menu..."
}

show_menu() {
    clear
    display_ascii_art
    echo "Choose an action:"
    PS3="Enter your choice: "

    options=(
        "Show IP"
        "System Info"
        "Disk Usage"
        "Network Test"
        "Git Status"
        "Ansible Ping"
        "Vault Status"
        "Tool Versions"
        "Clear Terraform Cache"
        "Clear Bash History"
        "Reload Shell"
        "Exit"
    )

    select opt in "${options[@]}"; do
        case $opt in
            "Show IP")
                echo
                echo "Local IP(s):"
                ip addr show | awk '/inet / && !/127.0.0.1/ {print " - " $2}'
                echo
                # Fetch public IP from an external service
                if command -v curl >/dev/null 2>&1; then 
                    pub=$(curl -s https://ifconfig.me) || echo "  Could not fetch public IP"
                elif command -v wget >/dev/null 2>&1; then
                    pub=$(wget -qO- https://ifconfig.me) || echo "  Could not fetch public IP"
                else
                    echo "  curl or wget not installed"
                fi
                echo "Public IP:" 
                echo " - $pub"  
                echo
                pause
                ;;
            "System Info")
                echo
                hostname
                echo
                cat /etc/os-release
                pause
                ;;
            "Disk Usage")
                echo
                df -h
                pause
                ;;
            "Network Test")
                echo
                # Unicode checkmark and cross
                GREEN="\033[0;32m"; RED="\033[0;31m"; NC="\033[0m"
                CHECK="\xE2\x9C\x85" # ✅
                CROSS="\xE2\x9D\x8C" # ❌

                echo "Running Task: Cloudflare DNS (1.1.1.1)"
                if ping -c 3 1.1.1.1 2>/dev/null > /dev/null; then
                    echo -e "${GREEN}${CHECK} Cloudflare DNS ${NC}"
                else
                    echo -e "${RED}${CROSS} Cloudflare DNS could not be resolved @ 1.1.1.1${NC}"
                fi

                echo "Running Task: Google DNS (8.8.8.8)"
                if ping -c 3 8.8.8.8 2>/dev/null > /dev/null; then
                    echo -e "${GREEN}${CHECK} Google DNS ${NC}"
                else
                    echo -e "${RED}${CROSS} Google DNS could not be resolved @ 8.8.8.8${NC}"
                fi

                echo "Running Task: Cloudflare (cloudflare.com)"
                if ping -c 3 cloudflare.com 2>/dev/null > /dev/null; then
                    echo -e "${GREEN}${CHECK} Cloudflare ${NC}"
                else
                    echo -e "${RED}${CROSS} Cloudflare could not be reached${NC}"
                fi

                echo "Running Task: Google (google.com)"
                if ping -c 3 google.com 2>/dev/null > /dev/null; then
                    echo -e "${GREEN}${CHECK} Google ${NC}"
                else
                    echo -e "${RED}${CROSS} Google.com could not be resolved${NC}"
                fi

                echo "Running Task: GitHub (github.com)"
                if ping -c 3 github.com 2>/dev/null > /dev/null; then
                    echo -e "${GREEN}${CHECK} GitHub ${NC}"
                else
                    echo -e "${RED}${CROSS} GitHub could not be reached${NC}"
                fi

                echo "Running Task: Azure (azure.com)"
                if ping -c 3 azure.com 2>/dev/null > /dev/null; then
                    echo -e "${GREEN}${CHECK} Azure ${NC}"
                else
                    echo -e "${RED}${CROSS} Azure could not be reached${NC}"
                fi

                echo "Running Task: AWS (aws.amazon.com)"
                if ping -c 3 aws.amazon.com 2>/dev/null > /dev/null; then
                    echo -e "${GREEN}${CHECK} AWS ${NC}"
                else
                    echo -e "${RED}${CROSS} AWS could not be reached${NC}"
                fi

                pause
                ;;
            "Git Status")
                echo
                git status -sb 2>/dev/null || echo "Not a git repository"
                pause
                ;;
            "Ansible Ping")
                echo
                ansible all -m ping 2>/dev/null || echo "Ansible inventory not available"
                pause
                ;;
            "Vault Status")
                echo
                vault status 2>/dev/null || echo "Vault not configured or unreachable"
                pause
                ;;
            "Tool Versions")
                echo
                terraform version
                echo
                ansible --version | head -n1
                echo
                vault version
                echo
                git --version
                pause
                ;;
            "Clear Terraform Cache")
                echo
                rm -rf .terraform .terraform.lock.hcl
                echo "Terraform cache cleared"
                pause
                ;;
            "Clear Bash History")
                echo
                history -c && history -w
                echo "Bash history cleared"
                pause
                ;;
            "Reload Shell")
                echo
                source ~/.bashrc
                echo "Shell environment reloaded"
                pause
                ;;
            "Exit")
                exit 0
                ;;
            *)
                echo
                echo "Invalid option"
                pause
                ;;
        esac

        show_menu
        break
    done
}

show_menu

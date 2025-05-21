#!/bin/bash

# --------------------------------------
# 🔧 Ubuntu System Setup Tool (Deluxe)
# Author: KraptuKrait
# Description: Checks, installs, and manages essential software on Ubuntu
# --------------------------------------

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

# Log file
LOGFILE="setup_log_$(date +%F_%H-%M-%S).log"

# Tool groups (customize as needed)
standard_tools=("curl" "git" "htop" "tree" "vim")
dev_tools=("build-essential" "gcc" "make" "gdb" "python3-pip")
network_tools=("net-tools" "nmap" "traceroute")

# Colored log output
log() {
  echo -e "$1"
  echo -e "$(date '+%F %T') - $1" >> "$LOGFILE"
}

# Show system info
show_system_info() {
  log "${CYAN}📊 System Information:${RESET}"
  echo "User: $USER"
  echo "Hostname: $(hostname)"
  echo "OS: $(lsb_release -d | cut -f2)"
  echo "Kernel: $(uname -r)"
  echo "Shell: $SHELL"
  echo "Free RAM: $(free -h | grep Mem | awk '{print $4}')"
  echo ""
}

# Check and install tool
check_and_install() {
  local tool=$1
  if ! command -v "$tool" &> /dev/null; then
    log "${YELLOW}❌ $tool is NOT installed.${RESET}"
    read -p "➡️  Do you want to install $tool? (y/n): " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      sudo apt install -y "$tool" >> "$LOGFILE" 2>&1
      log "${GREEN}✔️ $tool installed successfully.${RESET}"
    else
      log "${YELLOW}⚠️  $tool was skipped.${RESET}"
    fi
  else
    log "${GREEN}✅ $tool is already installed.${RESET}"
  fi
}

# Install a tool group
install_group() {
  local group_name=$1[@]
  local tools=("${!group_name}")
  log "${CYAN}🔧 Installing group: $1${RESET}"
  for prog in "${tools[@]}"; do
    check_and_install "$prog"
  done
}

# Main menu
main_menu() {
  clear
  log "${CYAN}🛠️ Welcome to the Ubuntu Setup Tool${RESET}"
  show_system_info

  echo -e "${CYAN}Choose an option:${RESET}"
  echo "1. Install standard tools"
  echo "2. Install developer tools"
  echo "3. Install network tools"
  echo "4. Check/install a single program"
  echo "5. Install all tool groups"
  echo "6. Exit"
  echo ""

  read -p "Your selection: " selection
  echo ""

  case $selection in
    1) install_group standard_tools ;;
    2) install_group dev_tools ;;
    3) install_group network_tools ;;
    4)
      read -p "🔎 Enter the program name: " singleprog
      check_and_install "$singleprog"
      ;;
    5)
      install_group standard_tools
      install_group dev_tools
      install_group network_tools
      ;;
    6)
      log "${CYAN}👋 Goodbye!${RESET}"
      exit 0
      ;;
    *)
      log "${RED}❌ Invalid selection!${RESET}"
      ;;
  esac

  echo ""
  read -p "🔁 Return to main menu? (y/n): " again
  if [[ "$again" =~ ^[Yy]$ ]]; then
    main_menu
  else
    log "${CYAN}📋 Log saved to $LOGFILE${RESET}"
    log "${CYAN}👋 Script finished.${RESET}"
    exit 0
  fi
}

# Start
sudo apt update >> "$LOGFILE" 2>&1
main_menu

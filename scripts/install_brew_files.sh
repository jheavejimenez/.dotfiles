#!/bin/bash

# Constant
LOG_FILE_PATH="logs/installation.log"
BREWFILE_PATH=~/.dotfiles/Brewfile

# Function to display log message
log() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE_PATH"
}

# Function to display status messages
show_status() {
    local messages="$1"
    echo "Status: $messages"
}

# Check if there's a log file
if [ -e "$LOG_FILE_PATH" ]; then
  read -p "Log file '$LOG_FILE_PATH' exists. Clear its contents? (y/n): " answer
    if [ "$answer" == "y" ]; then
        > "$LOG_FILE_PATH"
        echo "Log file cleared."
    else
        echo "Log file not cleared."
    fi
else
    touch "$LOG_FILE_PATH"
    echo "Log file created."
fi

# Check if the Brewfile exists
if [ -f "$BREWFILE_PATH" ]; then
    show_status "Installing packages from Brewfile"
    log "Installing packages from Brewfile"
    brew bundle --file="$BREWFILE_PATH"
else
    show_status "Brewfile not found at $BREWFILE_PATH. Make sure it exists."
    log "Brewfile not found at $BREWFILE_PATH. Make sure it exists."
fi

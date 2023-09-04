#!/bin/bash

# Constant
LOG_FILE_PATH="logs/installation.log"
BREWFILE_PATH=~/.dotfiles/Brewfile

# Function to display log message
log() {
    local messages="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE_PATH"
}

# Function to display status messages
show_status() {
    local messages="$1"
    echo "Status: $messages"
}

# Check if there's a log file
if [ -e "$LOG_FILE_PATH" ]; then
    read -p "Log file '$log_file' exists. Clear its contents? (y/n): " answer
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

# Check if Homebrew is already installed
if ! command -v brew &>/dev/null; then
    show_status "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    show_status "Homebrew is already installed."
fi

# Check if the Brewfile exists
if [ -f "$BREWFILE_PATH" ]; then
    show_status "Installing packages from Brewfile"
    brew bundle --file="$BREWFILE_PATH"
else
    show_status "Brewfile not found at $BREWFILE_PATH. Make sure it exists."
fi

# Define an array of dot file pairs (source and target)
dotfiles=(
    "~/.dotfiles/.zshrc ~/.zshrc"
    "~/.dotfiles/.gitconfig ~/.gitconfig"
    # Add more dot file pairs here
)

# Iterate through the dot file pairs and create symbolic links
for pair in "${dotfiles[@]}"; do
    read -r source target <<< "$pair"

    # Check if the source file exists
    if [ -e "$source" ]; then
        show_status "Creating symbolic link for $source"
        ln -s "$source" "$target"
    else
        show_status "Source file $source does not exist."
    fi
done

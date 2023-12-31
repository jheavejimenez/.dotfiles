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

setup_homebrew() {
  # Check if Homebrew is already installed
  if ! command -v brew &>/dev/null; then
      show_status "Installing Homebrew"
      log "Installing Homebrew"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      echo "You should run link command first before running brew_bundle command"
      exec $SHELL
  else
      show_status "Homebrew is already installed."
      log "Homebrew is already installed."
  fi

}

setup_homebrew_bundle() {
  # Check if the Brewfile exists
  if [ -f "$BREWFILE_PATH" ]; then
    show_status "Installing packages from Brewfile"
    log "Installing packages from Brewfile"
    brew bundle --file="$BREWFILE_PATH"
  else
    show_status "Brewfile not found at $BREWFILE_PATH. Make sure it exists."
    log "Brewfile not found at $BREWFILE_PATH. Make sure it exists."
  fi
}

setup_symlink() {
  # define an array of dot file pairs (source and target)
  dotfiles=(
      "~/.dotfiles/.gitconfig ~/.gitconfig"
      "~/.dotfiles/.zprofile ~/.zprofile"
      # Add more dot file pairs here
  )

  # Iterate through the dot file pairs and create symbolic links
  for pair in "${dotfiles[@]}"; do
      eval pair=($pair)  # This line performs tilde expansion
      source="${pair[0]}"
      target="${pair[1]}"

      # Check if the source file exists
      if [ -e "$source" ]; then
          show_status "Creating symbolic link for $source"
          log "Creating symbolic link for $source"
          ln -s "$source" "$target"
      else
          show_status "Source file $source does not exist."
          log "Source file $source does not exist."
      fi
  done
}

case "$1" in 
  link)
    setup_symlink
    ;;
  homebrew)
    setup_homebrew
    ;;
  brew_bundle)
    setup_homebrew_bundle
    ;;
  *)
    echo "Usage: $0 {link | homebrew | brew_bundle}"
    exit 1
    ;;
esac

show_status "Done set up"

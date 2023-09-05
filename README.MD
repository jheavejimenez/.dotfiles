## Bootstrapping a New Mac

These straightforward instructions will help you efficiently configure your new Mac, ensuring that it's ready for productive use. 
Follow each step below to streamline the setup process.

Step 1: Install Apple's Command Line Tools

Before proceeding, you need to install Apple's Command Line Tools. Open your terminal and execute the following command:

```zsh
xcode-select --install
```

Step 2: Create Symlinks

Create symbolic links (symlinks) for configuration files in your Home directory. While there are more automated methods available, this manual approach provides a quick start:

```zsh
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
```


Step 3: Install Homebrew and Software

Install Homebrew, a package manager for macOS, and use it to install the software listed in your Brewfile:

```zsh
# These could also be in an install script.

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then pass in the Brewfile location...
brew bundle --file ~/.dotfiles/Brewfile

```
By following these steps, you'll have a well-configured Mac with essential tools and software ready to go.

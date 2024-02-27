#!/bin/bash

echo "Initializing submodules..."

git submodule update --init --recursive

echo "Installing deps..."

# Check for apt (Debian/Ubuntu)
if command -v apt >/dev/null 2>&1; then
  echo "Using apt"
  sudo apt update && sudo apt install -y zsh vim

# Check for brew (macOS)
elif command -v brew >/dev/null 2>&1; then
  echo "Using brew"
  brew update && brew install zsh vim

# Check for pacman (Arch Linux)
elif command -v pacman >/dev/null 2>&1; then
  echo "Using pacman"
  sudo pacman -Syu zsh vim

else
  echo "No recognized package manager found."
fi
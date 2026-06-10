#!/usr/bin/env bash
set -euo pipefail

SUBLIME_USER="$HOME/.config/sublime-text/Packages/User"

echo "==> Sublime Text Config Installer for Linux"
echo ""

# ── 1. Ensure Sublime Text config dir exists ──────────────────────────
if [ ! -d "$HOME/.config/sublime-text/Packages" ]; then
  echo "Sublime Text config not found. Creating directories..."
  mkdir -p "$SUBLIME_USER"
fi

# ── 2. Install Package Control (if not present) ────────────────────────
PC_DIR="$HOME/.config/sublime-text/Installed Packages"
PC_FILE="$PC_DIR/Package Control.sublime-package"
if [ ! -f "$PC_FILE" ]; then
  echo "Downloading Package Control..."
  mkdir -p "$PC_DIR"
  wget -q "https://packagecontrol.io/Package%20Control.sublime-package" -O "$PC_FILE"
  echo "Package Control installed."
else
  echo "Package Control already present."
fi

# ── 3. Copy user config files ──────────────────────────────────────────
echo "Copying user settings..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cp "$SCRIPT_DIR/User/Preferences.sublime-settings"           "$SUBLIME_USER/"
cp "$SCRIPT_DIR/User/Package Control.sublime-settings"       "$SUBLIME_USER/"
cp "$SCRIPT_DIR/User/Default (Linux).sublime-keymap"         "$SUBLIME_USER/"
cp "$SCRIPT_DIR/User/LSP.sublime-settings"                   "$SUBLIME_USER/"
cp "$SCRIPT_DIR/User/LSP-clangd.sublime-settings"            "$SUBLIME_USER/"
cp "$SCRIPT_DIR/User/Monokai True Dark.sublime-color-scheme" "$SUBLIME_USER/"
cp "$SCRIPT_DIR/User/Monokai True Dark.sublime-theme"        "$SUBLIME_USER/"

mkdir -p "$SUBLIME_USER/LSP"
cp "$SCRIPT_DIR/User/LSP/inlay_hints.css"                    "$SUBLIME_USER/LSP/"

mkdir -p "$SUBLIME_USER/Terminus"
cp "$SCRIPT_DIR/User/Terminus/Terminus.hidden-color-scheme"  "$SUBLIME_USER/Terminus/"

# ── 4. Copy third-party package settings ───────────────────────────────
echo "Copying package settings..."
mkdir -p "$HOME/.config/sublime-text/Packages/CppFastOlympicCoding"
cp "$SCRIPT_DIR/CppFastOlympicCoding/FastOlympicCoding (Linux).sublime-settings" \
   "$HOME/.config/sublime-text/Packages/CppFastOlympicCoding/"
cp "$SCRIPT_DIR/CppFastOlympicCoding/TestSyntax.sublime-settings" \
   "$HOME/.config/sublime-text/Packages/CppFastOlympicCoding/"

# ── 5. Copy manual packages (CPBuddy - not on Package Control) ────────
echo "Copying manual packages..."
if [ -d "$SCRIPT_DIR/CPBuddy" ]; then
  rm -rf "$HOME/.config/sublime-text/Packages/CPBuddy"
  cp -r "$SCRIPT_DIR/CPBuddy" "$HOME/.config/sublime-text/Packages/"
fi

# ── 6. Install packages via Package Control ────────────────────────────
# Packages will be auto-installed when Sublime Text starts with
# the Package Control.sublime-settings in place. The 'installed_packages'
# list in that file tells Package Control what to fetch.
echo ""
echo "==> INSTALLATION COMPLETE =="
echo ""
echo "Next steps:"
echo "  1. Launch Sublime Text"
echo "  2. Wait for Package Control to download all packages"
echo "     (check status in the bottom-left corner)"
echo "  3. Restart Sublime Text once all packages are installed"
echo ""
echo "Packages to be installed:"
cat "$SCRIPT_DIR/installed-packages.txt"
echo ""
echo "If clangd is not installed on your system, install it:"
echo "  sudo apt install clangd     # Debian/Ubuntu"
echo "  sudo dnf install clangd     # Fedora"
echo "  sudo pacman -S clangd       # Arch"

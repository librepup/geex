#!/usr/bin/env bash

# Case Config File
case "$1" in
    config|c)
        export configPath="$HOME/.config/waybar"
        export configFile="$configPath/config.jsonc"
        ;;
    geex|g)
        export configPath="$HOME/Geex/files/config/waybar"
        export configFile="$HOME/Geex/files/config/waybar/config.jsonc"
        ;;
    *|"")
        export configPath="$HOME/Geex/files/config/waybar"
        export configFile="$HOME/Geex/files/config/waybar/config.jsonc"
        ;;
esac

# Case Theme
case "$2" in
    guix|g)
        export waybarTheme="guix.css"
        ;;
    jungle|j)
        export waybarTheme="jungle.css"
        ;;
    default|d)
        export waybarTheme="style.css"
        ;;
    *|"")
        export waybarTheme="jungle.css"
        ;;
esac

# If Waybar already Running, Kill - else, Start
if ps -e | grep "[w]aybar"; then
    pkill waybar
else
    if [ -d ~/.config/waybar ] || [ -d ~/Geex/files/config/waybar ]; then
        echo "Found Config Directories"
    else
        echo "Config Directories Missing"
    fi
    waybar --config $configFile --style $configPath/$waybarTheme &
fi

# Unset Exported Variables
unset waybarTheme
unset configPath
unset configFile

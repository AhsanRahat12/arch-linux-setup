#!/bin/bash

# Resolve the symlink to get the actual directory path
WALLPAPER_DIR="$(readlink -f $HOME/.config/backgrounds)"

echo "Resolved wallpaper directory: $WALLPAPER_DIR"

# Kill any existing hyprpaper instance
pkill hyprpaper

# Find a random wallpaper using the resolved path
WALLPAPER=$(find "$WALLPAPER_DIR" -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" | shuf -n 1)

# Check if we found any wallpapers
if [ -z "$WALLPAPER" ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

echo "Selected wallpaper: $WALLPAPER"

# Create temporary hyprpaper config
cat > /tmp/hyprpaper.conf << EOF
preload = $WALLPAPER
wallpaper = ,$WALLPAPER
EOF

# Start hyprpaper with the new config
hyprpaper -c /tmp/hyprpaper.conf &

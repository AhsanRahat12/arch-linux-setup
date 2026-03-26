#!/bin/bash
# Log to file
exec >> /tmp/wallpaper-script.log 2>&1
echo "=== Wallpaper script started at $(date) ==="

# Wait for Hyprland to fully initialize
sleep 5

# Kill any existing hyprpaper for fresh start
pkill hyprpaper
sleep 2

# Start fresh hyprpaper
hyprpaper &
sleep 2

# Get wallpaper directory
WALLPAPER_DIR="$(readlink -f $HOME/.config/backgrounds)"

# Function to change wallpaper
change_wallpaper() {
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) | shuf -n 1)

    if [ -z "$WALLPAPER" ]; then
        echo "No wallpapers found"
        return
    fi

    echo "$(date): Selected: $WALLPAPER"
    hyprctl hyprpaper preload "$WALLPAPER"
    hyprctl hyprpaper wallpaper ",$WALLPAPER"
}

# Change wallpaper immediately on startup
change_wallpaper

# Change every 25 minutes
while true; do
    sleep 1500
    change_wallpaper
done

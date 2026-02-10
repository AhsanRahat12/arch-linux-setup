#!/bin/bash
# ~/scripts/check-updates.sh

OUTPUT_FILE="$HOME/.cache/update-check.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Function to send notification
send_notification() {
    local title="$1"
    local message="$2"
    export DISPLAY=:0
    export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
    notify-send "$title" "$message" -u normal -i system-software-update
}

UPDATES_FOUND=false
UPDATE_SUMMARY=""

# Save everything to log file
{
    echo "========================================="
    echo "Update Check: $TIMESTAMP"
    echo "========================================="
    echo ""

    # System packages
    echo "System Packages (official repos)..."
    # Sync the database first
    sudo pacman -Sy > /dev/null 2>&1
    # Now check for updates
    SYSTEM_UPDATES=$(pacman -Qu 2>/dev/null | grep -v "aur/")
    if [ -n "$SYSTEM_UPDATES" ]; then
        COUNT=$(echo "$SYSTEM_UPDATES" | wc -l)
        echo "$SYSTEM_UPDATES"
        echo "→ To update: sudo pacman -Syu"
        UPDATES_FOUND=true
        UPDATE_SUMMARY+="📦 $COUNT system package(s)\n"
    else
        echo "No updates available"
    fi
    echo ""

    # AUR packages
    echo "AUR Packages..."
    AUR_UPDATES=$(pacman -Qu 2>/dev/null | grep "aur/")
    if [ -n "$AUR_UPDATES" ]; then
        COUNT=$(echo "$AUR_UPDATES" | wc -l)
        echo "$AUR_UPDATES"
        echo "→ To update: paru -Syu (or yay -Syu)"
        UPDATES_FOUND=true
        UPDATE_SUMMARY+="🔧 $COUNT AUR package(s)\n"
    else
        echo "No updates available"
    fi
    echo ""

    # Firmware updates
    echo "Firmware Updates..."
    FIRMWARE_UPDATES=$(fwupdmgr get-updates 2>/dev/null)
    if [ -n "$FIRMWARE_UPDATES" ] && ! echo "$FIRMWARE_UPDATES" | grep -q "No updates available"; then
        echo "$FIRMWARE_UPDATES"
        echo "→ To update: fwupdmgr update"
        UPDATES_FOUND=true
        UPDATE_SUMMARY+="⚡ Firmware updates available\n"
    else
        echo "No updates available"
    fi
    echo ""

    # Flatpak updates (if installed)
    if command -v flatpak &> /dev/null; then
        echo "Flatpak Packages..."
        FLATPAK_UPDATES=$(flatpak remote-ls --updates 2>/dev/null)
        if [ -n "$FLATPAK_UPDATES" ]; then
            COUNT=$(echo "$FLATPAK_UPDATES" | wc -l)
            echo "$FLATPAK_UPDATES"
            echo "→ To update: flatpak update"
            UPDATES_FOUND=true
            UPDATE_SUMMARY+="📱 $COUNT Flatpak package(s)\n"
        else
            echo "No updates available"
        fi
        echo ""
    fi

    echo "========================================="

} | tee "$OUTPUT_FILE"

# Send notification if updates were found
if [ "$UPDATES_FOUND" = true ]; then
    send_notification "Updates Available" "$(echo -e "$UPDATE_SUMMARY")\n\nCheck $OUTPUT_FILE for details"
else
    send_notification "System Up to Date" "No updates available"
fi

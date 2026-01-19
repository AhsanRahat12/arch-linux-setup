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
    AUR_UPDATES=$(paru -Qu 2>/dev/null | grep "aur/")
    if [ -n "$AUR_UPDATES" ]; then
        COUNT=$(echo "$AUR_UPDATES" | wc -l)
        echo "$AUR_UPDATES"
        echo "→ To update: paru -Sua"
        UPDATES_FOUND=true
        UPDATE_SUMMARY+="📦 $COUNT AUR package(s)\n"
    else
        echo "No AUR updates available"
    fi
    echo ""

    # Firmware
    echo "Firmware updates..."
    if command -v fwupdmgr &> /dev/null; then
        fwupdmgr refresh &> /dev/null
        FW_UPDATES=$(fwupdmgr get-updates 2>&1)
        if echo "$FW_UPDATES" | grep -q "No updates available\|Devices with no available firmware"; then
            echo "No firmware updates"
        else
            fwupdmgr get-updates
            echo "→ To update: fwupdmgr update"
            UPDATES_FOUND=true
            UPDATE_SUMMARY+="🔧 Firmware updates available\n"
        fi
    else
        echo "fwupd not installed"
    fi
    echo ""

    # Bootloader
    echo "Bootloader (systemd-boot)..."
    BOOTCTL_STATUS=$(sudo bootctl status 2>&1)
    echo "$BOOTCTL_STATUS" | grep -E "Current:|Available:"
    echo "→ To update: sudo bootctl update"
    echo ""

    # Flatpak
    echo "Flatpak packages..."
    if command -v flatpak &> /dev/null; then
        FLATPAK_UPDATES=$(flatpak remote-ls --updates 2>/dev/null)
        if [ -n "$FLATPAK_UPDATES" ]; then
            COUNT=$(echo "$FLATPAK_UPDATES" | wc -l)
            echo "$FLATPAK_UPDATES"
            echo "→ To update: flatpak update"
            UPDATES_FOUND=true
            UPDATE_SUMMARY+="📦 $COUNT Flatpak package(s)\n"
        else
            echo "No Flatpak updates"
        fi
    else
        echo "Flatpak not installed"
    fi
    echo ""

    # Orphaned packages
    echo "Orphaned packages..."
    ORPHANS=$(pacman -Qtdq 2>/dev/null)
    if [ -n "$ORPHANS" ]; then
        COUNT=$(echo "$ORPHANS" | wc -l)
        echo "Found $COUNT orphaned package(s):"
        echo "$ORPHANS"
        echo "→ To remove: paru -Rns \$(pacman -Qtdq)"
        UPDATES_FOUND=true
        UPDATE_SUMMARY+="🗑️  $COUNT orphaned package(s)\n"
    else
        echo "No orphaned packages"
    fi
    echo ""

    # Package cache
    echo "Package cache..."
    CACHE_SIZE=$(du -sh /var/cache/pacman/pkg/ 2>/dev/null | cut -f1)
    echo "Cache size: $CACHE_SIZE"
    echo "→ Clean old versions: sudo pacman -Sc"
    echo ""

    echo "========================================="
    echo "Check Complete"
    echo "========================================="

} > "$OUTPUT_FILE"

# Send notification
if [ "$UPDATES_FOUND" = true ]; then
    send_notification "Updates Available" "$(echo -e $UPDATE_SUMMARY)Press Super+U to view details"
else
    send_notification "System Up to Date" "No updates available"
fi

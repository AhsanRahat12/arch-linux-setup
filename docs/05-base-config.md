# Base System Configuration

## Package Installation

### Install Base System
```bash
# Install essential packages to mounted root
pacstrap -K /mnt base linux linux-firmware
```
This installs:
- **base**: Essential Arch Linux base system
- **linux**: Linux kernel
- **linux-firmware**: Hardware firmware files

## Filesystem Table (fstab)

### Generate fstab
```bash
# Generate filesystem table for automatic mounting
genfstab -U /mnt >> /mnt/etc/fstab
```
- `-U` flag uses UUIDs instead of device names for reliability
- Automatically configures mount points for boot, root, home, and swap

## System Environment Setup

### Enter New System
```bash
# Change root into the new system
arch-chroot /mnt
```
This allows configuration of the installed system rather than the live environment.

## Time Configuration

### Set Timezone
```bash
# Link timezone file (adjust for your location)
ln -sf /usr/share/zoneinfo/America/Winnipeg /etc/localtime
```

### Sync Hardware Clock
```bash
# Synchronize hardware clock with system time
hwclock --systohc
```

### Verify Time
```bash
# Check current time setting
date
```

## Essential Tools Installation

### Install Text Editor
```bash
# Install vim for configuration file editing
pacman -Syu vim
```

## Localization Setup

### Configure Locale Generation
```bash
# Edit locale generation file
vim /etc/locale.gen
```
**Action**: Uncommented `en_US.UTF-8 UTF-8` line

### Generate Locales
```bash
# Generate the locales from configuration
locale-gen
```

### Set System Locale
```bash
# Create locale configuration file
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
```

## Configuration Files Created

### /etc/fstab
- Automatic mounting configuration for all filesystems
- Uses UUIDs for device identification
- Configures mount options for performance and reliability

### /etc/localtime
- Symlink to appropriate timezone data
- Ensures correct local time display

### /etc/locale.conf
- System-wide locale settings
- Defines language and character encoding

### /etc/locale.gen
- Controls which locales are generated
- Enables UTF-8 support for international characters

## Key Concepts

### chroot Environment
- **Purpose**: Configure installed system from live environment
- **Benefits**: Allows modification of target system before first boot
- **Usage**: All subsequent configuration happens within chroot

### UUID vs Device Names
- **UUIDs**: Persistent across reboots and hardware changes
- **Device names**: Can change with hardware modifications
- **Reliability**: UUID-based fstab prevents boot issues

### Locale Configuration
- **Importance**: Defines system language and character handling
- **UTF-8**: Universal character encoding for international support
- **System-wide**: Affects all user sessions and applications

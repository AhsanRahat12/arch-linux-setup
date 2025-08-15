# Booting the Install Medium

## BIOS Configuration

### 1. Access BIOS/UEFI
- Entered BIOS mode during laptop startup
- **Disabled Secure Boot** (required for most Linux distributions)
- Set USB as primary boot device

### 2. Boot Selection
- Restarted system and pressed **F12** during boot
- Selected "Arch Linux" from the boot menu
- System successfully booted into Arch Linux live environment

## Hardware Compatibility Issues

### ACPI Errors
Encountered multiple ACPI (Advanced Configuration and Power Interface) errors during boot:

```bash
# Disable kernel messages to regain terminal access
dmesg -D
```

This command suppressed the error messages and restored terminal functionality. These errors are common on certain hardware and typically don't affect installation.

## Network Setup

### Wireless Configuration
Connected to WiFi using the `iwctl` wireless daemon:

```bash
# Enter wireless configuration mode
iwctl

# Scan for available networks
station wlan0 get-networks

# Connect to network (will prompt for password)
station wlan0 connect <WiFi_name>

# Verify connection
station wlan0 show

# Exit iwctl (Ctrl+C)
exit
```

### Internet Verification
```bash
# Test internet connectivity
curl google.com
```

## Initial Security Setup
```bash
# Change root password for live session
passwd
```

## Key Takeaways
- Hardware compatibility issues (ACPI errors) can often be worked around
- `dmesg -D` is useful for suppressing non-critical kernel messages
- Always verify internet connectivity before proceeding with installation

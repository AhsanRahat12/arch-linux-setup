# Bootloader Setup and User Configuration

## Bootloader Installation

### Exit chroot and Install systemd-boot
```bash
# Exit the chroot environment
exit

# Install systemd-boot bootloader to EFI partition
bootctl --esp-path=/mnt/boot install

# Re-enter chroot for configuration
arch-chroot /mnt

# Confirm bootloader installation
bootctl install

# Update bootloader
bootctl update
```

## Boot Entry Configuration

### Create Arch Linux Boot Entry
```bash
# Create boot configuration file
vim /boot/loader/entries/arch.conf
```

**Boot entry configuration:**
```ini
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options rd.luks.name=<UUID>=cryptlvm root=/dev/mimir1/root rw
```

**Configuration breakdown:**
- **title**: Display name in boot menu
- **linux**: Kernel image location
- **initrd**: Initial RAM disk location
- **options**: Kernel boot parameters

### Boot Parameters Explained
- **rd.luks.name=\<UUID\>=cryptlvm**: 
  - Tells systemd to unlock LUKS device
  - Maps encrypted partition to `cryptlvm`
  - UUID should match your encrypted partition
- **root=/dev/mimir1/root**: 
  - Specifies root filesystem location
  - Points to LVM logical volume
- **rw**: Mount root filesystem as read-write

## User Management

### Create User Account
```bash
# Create user 'rahat' with home directory and wheel group
useradd -m -G wheel rahat
```

**Parameters explained:**
- **-m**: Create home directory
- **-G wheel**: Add to wheel group (for sudo access)
- **rahat**: Username

### Configure Sudo Access
```bash
# Edit sudoers file
visudo
```

**Modified line:**
```bash
# Uncomment this line:
%wheel ALL=(ALL:ALL) ALL
```
This grants sudo privileges to all members of the wheel group.

## Password Configuration

### Set Root Password
```bash
# Set password for root user
passwd
```

### Set User Password
```bash
# Set password for user 'rahat'
passwd rahat
```

## systemd-boot Advantages

### Why systemd-boot?
- **UEFI native**: Designed specifically for UEFI systems
- **Simple**: Minimal configuration required
- **Fast**: Quick boot times
- **Integrated**: Part of systemd ecosystem
- **Secure**: Supports Secure Boot (when configured)

### Boot Process Flow
```
UEFI Firmware
    ↓
systemd-boot (bootloader)
    ↓
User selects boot entry
    ↓
Loads kernel + initramfs
    ↓
Kernel starts systemd in initramfs
    ↓
User enters LUKS passphrase
    ↓
System unlocks and boots
```

## Security Configuration

### User Security Model
- **Root account**: Administrative access only
- **Regular user**: Daily usage account
- **Sudo access**: Controlled privilege escalation
- **Wheel group**: Standard administrative group

### Boot Security
- **LUKS integration**: Automatic encryption handling
- **UUID mapping**: Reliable device identification
- **Minimal exposure**: Only boot partition unencrypted

## Configuration Validation

Before exiting, verify:
- ✅ systemd-boot installed to EFI partition
- ✅ Boot entry created with correct parameters
- ✅ User account created with sudo access
- ✅ Passwords set for both root and user
- ✅ Wheel group configured for

The system is now ready for first boot with:
- Encrypted disk unlocking
- User authentication
- Full system access

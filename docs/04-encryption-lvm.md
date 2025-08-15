# Encryption and LVM Setup

## Encryption Overview
Using **dm-crypt** with **LUKS** (Linux Unified Key Setup) for full disk encryption with passphrase authentication.

## Encryption Process

### 1. Initialize LUKS Encryption
```bash
# Encrypt the LVM partition with LUKS
cryptsetup luksFormat /dev/nvme0n1p2
```
This command:
- Prompts for encryption passphrase
- Sets up LUKS header on the partition
- Overwrites existing data for security

### 2. Open Encrypted Volume
```bash
# Unlock and map the encrypted partition
cryptsetup open /dev/nvme0n1p2 cryptlvm
```
- Prompts for the passphrase
- Creates `/dev/mapper/cryptlvm` device mapping
- Allows access to encrypted data

## LVM Configuration

### Physical Volume Creation
```bash
# Create LVM physical volume on encrypted device
pvcreate /dev/mapper/cryptlvm
```

### Volume Group Creation
```bash
# Create volume group named "mimir1"
vgcreate mimir1 /dev/mapper/cryptlvm
```

### Logical Volume Creation
```bash
# Create logical volumes for different purposes
lvcreate -L 8G -n swap mimir1 && \
lvcreate -L 32G -n root mimir1 && \
lvcreate -l 100%FREE -n home mimir1
```

**Volume allocation:**
- **swap**: 8GB (for hibernation/swap space)
- **root**: 32GB (system files)
- **home**: Remaining space (user data)

## Storage Stack Architecture
```
Physical Disk (NVMe SSD)
    ↓
LUKS Encryption Layer
    ↓
LVM Physical Volume
    ↓
Volume Group "mimir1"
    ↓
Logical Volumes (swap, root, home)
```

## Filesystem Creation

### Format Logical Volumes
```bash
# Create ext4 filesystems
mkfs.ext4 /dev/mimir1/root
mkfs.ext4 /dev/mimir1/home

# Setup swap
mkswap /dev/mimir1/swap
swapon /dev/mimir1/swap
```

### Format Boot Partition
```bash
# Create FAT32 filesystem for UEFI boot
mkfs.fat -F32 /dev/nvme0n1p1
```

## Mount Structure

### Mount Points Setup
```bash
# Mount root filesystem
mount /dev/mimir1/root /mnt

# Create and mount boot directory
mount /dev/nvme0n1p1 /mnt/boot

# Create and mount home directory
mkdir /mnt/home
mount /dev/mimir1/home /mnt/home
```

### Final Mount Structure
```
/mnt/                    ← /dev/mimir1/root (encrypted)
├── /mnt/boot/          ← /dev/nvme0n1p1 (unencrypted)
└── /mnt/home/          ← /dev/mimir1/home (encrypted)
```

## Security Benefits
- **Data protection**: All user data encrypted at rest
- **Key management**: Single passphrase for entire system
- **Boot security**: Only boot partition remains unencrypted (required)
- **Performance**: Hardware-accelerated AES encryption on modern CPUs

## LVM Advantages
- **Flexibility**: Easy resizing of logical volumes
- **Snapshots**: Can create filesystem snapshots for backups
- **Spanning**: Can add more physical devices later
- **Migration**: Can move logical volumes between devices


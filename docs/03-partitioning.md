# Disk Partitioning

## System Verification

### Boot Mode Check
```bash
# Verify UEFI boot mode (should return 64)
cat /sys/firmware/efi/fw_platform_size
```
Output: `64` - Confirmed system booted in UEFI mode.

### Time Synchronization
```bash
# Synchronize system clock
timedatectl
```

### Storage Analysis
```bash
# List all block devices
lsblk
```
My system uses `/dev/nvme0n1` format (NVMe SSD).

## Partitioning Strategy

### Design Decisions
- **LVM (Logical Volume Manager)**: Chosen for flexibility and future expansion
- **Two-partition scheme**: 
  - 1GB boot partition (EFI)
  - Remaining space for encrypted LVM
- **Full disk encryption**: Enhanced security with LUKS passphrase
- **Logical volumes**: Separate volumes for swap, root, and home

### Benefits of This Approach
- **Resizable partitions**: LVM allows future resizing
- **Multi-device spanning**: Can add more storage devices later
- **Security**: Full disk encryption protects data at rest
- **Flexibility**: Separate home partition for easier OS reinstallation

## Partitioning Process

### Disk Preparation
Since the system previously had Ubuntu installed, existing partitions needed removal.

### Using fdisk
```bash
# Enter interactive partitioning tool
fdisk /dev/nvme0n1
```

#### Partition Layout Created:
1. **Boot Partition** (`/dev/nvme0n1p1`)
   - Size: 1GB
   - Type: EFI System Partition
   - Format: FAT32

2. **LVM Partition** (`/dev/nvme0n1p2`)
   - Size: Remaining disk space
   - Type: Linux LVM
   - Will be encrypted with LUKS

### Final Partition Structure
```
/dev/nvme0n1
├── /dev/nvme0n1p1  (1GB, EFI boot)
└── /dev/nvme0n1p2  (Remaining, LVM encrypted)
```

## Key Considerations
- **UEFI compatibility**: Separate boot partition required
- **Future flexibility**: LVM allows for easy partition management
- **Security first**: Encryption applied to data partition only (boot must remain unencrypted)
- **Performance**: NVMe SSD provides excellent I/O performance for encrypted volumes


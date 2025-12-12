# My Arch Linux Build

A complete bare-metal Arch Linux installation with encrypted LVM, Hyprland window manager, and custom theming. This repository documents my journey from a fresh install to a fully configured desktop environment.

## 🖥️ System Specifications

- **Hardware**: Personal laptop (bare metal installation)
- **Storage**: NVMe SSD with full disk encryption (LUKS + LVM)
- **Desktop Environment**: Hyprland (Wayland compositor)
- **Theme**: Catppuccin-inspired with Typecraft dotfiles

## 📸 Screenshots

### Base Installation
![Base Install](screenshots/Base_Setup.png)

### Final Desktop Setup
| Background & Waybar | Terminal & Wofi |
|---------------------|-----------------|
| ![Background](screenshots/Background&Waybar.png) | ![Terminal](screenshots/Terminal&Wofi.png) |

## 🚀 Quick Overview

This build demonstrates:
- **Manual Arch installation** (no automated scripts)
- **Full disk encryption** with LUKS + LVM
- **Modern Wayland setup** with Hyprland
- **Professional theming** and customization
- **Native Wayland app support** with proper scaling
- **AUR package management** with paru
- **Comprehensive documentation** of the entire process

## 📋 Installation Guide

### Phase 1: Base System
1. [**Creating Install Medium**](docs/01-install-medium.md) - ISO download and USB flashing
2. [**Boot Process**](docs/02-booting.md) - BIOS setup and initial boot
3. [**Disk Partitioning**](docs/03-partitioning.md) - UEFI boot + LVM partition scheme
4. [**Encryption & LVM**](docs/04-encryption-lvm.md) - LUKS encryption with logical volumes
5. [**System Configuration**](docs/05-base-config.md) - fstab, timezone, and localization
6. [**Networking**](docs/06-networking.md) - systemd-networkd and wireless setup
7. [**Boot Configuration**](docs/07-mkinitcpio.md) - initramfs with encryption hooks
8. [**Bootloader**](docs/08-bootloader.md) - systemd-boot installation and configuration

### Phase 2: Desktop Environment
9. [**First Boot**](docs/09-first-boot.md) - Initial system verification
10. [**Hyprland Installation**](docs/10-hyprland.md) - Window manager and essential packages
11. [**AUR Helper Setup**](docs/11-aur-helper.md) - Installing paru for AUR packages
12. [**Desktop Components**](docs/12-finishing-touches.md) - Screenshots, notifications, lock screen

### Phase 3: Theming & Customization
13. [**Visual Theming**](docs/13-theming.md) - Catppuccin theme implementation with dotfiles

## 🛠️ Key Technologies Used

- **Encryption**: LUKS (dm-crypt) with passphrase authentication
- **Volume Management**: LVM2 for flexible storage management
- **Window Manager**: Hyprland (Wayland-based tiling compositor)
- **Display Protocol**: Native Wayland with Electron app optimization
- **Audio**: PipeWire with PulseAudio compatibility
- **Status Bar**: Waybar with Font Awesome icons
- **Application Launcher**: Wofi
- **Terminal**: Kitty with Starship prompt
- **Shell**: Bash with custom configurations
- **Editor**: Vim with personalized vimrc
- **Package Management**: Pacman + Paru (AUR helper)

## 🔧 Configuration Files

All configuration files are organized in the [`configs/`](configs/) directory:

```
configs/
├── bash/           # Shell configuration and aliases
├── vim/            # Vim editor configuration
├── hypr/           # Hyprland configuration (with Wayland optimizations)
├── waybar/         # Status bar configuration  
├── kitty/          # Terminal configuration
├── wofi/           # Application launcher
├── hyprlock/       # Lock screen configuration
└── starship/       # Shell prompt configuration
```

### Notable Configurations

**Hyprland Wayland Optimizations**
- Native Wayland support for Electron apps (VS Code, Obsidian, Discord)
- Proper fractional scaling without blur
- Environment variables configured for optimal display rendering

**Shell Configuration**
- Custom bash aliases for productivity
- Efficient command shortcuts
- Development workflow optimizations

**Vim Setup**
- Personalized vimrc for efficient text editing
- Custom keybindings and settings

## 💡 Key Learning Points

### Security Considerations
- **Full disk encryption** protects data at rest
- **Separate boot partition** for UEFI compatibility
- **LVM flexibility** allows for future storage expansion

### System Architecture
- **Wayland over X11** for modern display protocol
- **Native Wayland rendering** eliminates XWayland scaling issues
- **systemd services** for network management
- **PipeWire** replaces older audio systems (ALSA/PulseAudio)

### Display Server Deep Dive
- Understanding XWayland compatibility layer limitations
- Configuring native Wayland support for Electron applications
- Solving fractional scaling blur through proper Ozone platform configuration
- Environment variable tuning for optimal high-DPI display rendering

### Development Workflow
- **Manual installation** builds deep system understanding
- **AUR integration** provides access to community packages
- **Dotfiles management** ensures reproducible configurations
- **Shell customization** enhances daily productivity

## 🎯 Why This Build?

This setup demonstrates several key technical skills:

1. **System Administration**: Manual Arch installation shows deep Linux knowledge
2. **Security Awareness**: Full disk encryption implementation
3. **Modern Technologies**: Wayland, PipeWire, systemd adoption  
4. **Display Server Expertise**: Native Wayland configuration and troubleshooting
5. **Customization Skills**: Theming and dotfiles management
6. **Documentation**: Clear, comprehensive setup guide
7. **Problem Solving**: Troubleshooting hardware compatibility and display issues

## 🔍 Hardware Compatibility Notes

- **ACPI Errors**: Resolved with `dmesg -D` during initial boot
- **Display Scaling**: Configured 1.5x scaling for optimal clarity
- **Electron App Blur**: Solved with native Wayland environment variables
- **Graphics**: Mesa drivers for hardware acceleration
- **Audio**: PipeWire configuration for seamless audio routing

## 🐛 Common Issues Solved

### Blurry Electron Apps on Wayland
**Problem**: VS Code, Obsidian, and Discord appeared blurry with fractional scaling (150%)

**Solution**: Configured native Wayland rendering in Hyprland:
```bash
env = ELECTRON_ENABLE_WAYLAND,1
env = ELECTRON_OZONE_PLATFORM_HINT,wayland
```

This bypasses XWayland compatibility layer and enables proper fractional scaling support.

## 📚 Resources & Inspiration

- [Arch Linux Wiki](https://wiki.archlinux.org/) - Comprehensive documentation
- [Typecraft Dotfiles](https://github.com/typecraft-dev/dotfiles) - Configuration inspiration
- [Catppuccin Theme](https://github.com/catppuccin/catppuccin) - Color scheme
- [Hyprland Documentation](https://wiki.hyprland.org/) - Wayland compositor configuration

## 🤝 Usage

This repository serves as:
- **Personal reference** for future installations
- **Learning resource** for others attempting similar setups
- **Portfolio demonstration** of Linux system administration skills
- **Troubleshooting guide** for common Arch + Wayland issues

Feel free to use any configurations or adapt the setup process for your own needs.

## 🚀 Quick Setup

To use these configurations on a fresh Arch install:

```bash
# Clone the repository
git clone https://github.com/yourusername/arch-linux-setup.git
cd arch-linux-setup

# Copy configurations to appropriate locations
cp configs/bash/bashrc ~/.bashrc
cp configs/vim/vimrc ~/.vimrc
cp -r configs/hypr ~/.config/
cp -r configs/waybar ~/.config/
cp -r configs/kitty ~/.config/
cp -r configs/wofi ~/.config/
cp -r configs/starship ~/.config/

# Reload shell
source ~/.bashrc
```

---

*Built on bare metal hardware - no VMs, no safety nets, just pure Arch Linux.*

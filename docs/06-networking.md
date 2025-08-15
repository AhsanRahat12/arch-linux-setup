# Network Configuration

## Overview
Setting up systemd-based networking for wireless connectivity using modern systemd services.

## System Network Services

### Enable Core Services
```bash
# Enable systemd networking daemon
systemctl enable systemd-networkd.service

# Enable DNS resolution service
systemctl enable systemd-resolved.service
```

**Services explanation:**
- **systemd-networkd**: Manages network configuration
- **systemd-resolved**: Handles DNS resolution and caching

## Network Configuration Files

### Check Main Configuration
```bash
# View networkd configuration
vim /etc/systemd/networkd.conf
```

### Wireless Interface Configuration
```bash
# Create wireless network configuration
vim /etc/systemd/network/25-wireless.network
```

**Configuration added:**
```ini
[Match]
Name=wlan0

[Network]
DHCP=yes
IgnoreCarrierLoss=3
```

**Configuration explanation:**
- **Match**: Applies to wireless interface `wlan0`
- **DHCP=yes**: Automatically obtain IP address
- **IgnoreCarrierLoss=3**: Maintains connection during brief signal loss

## Wireless Management

### Install Wireless Daemon
```bash
# Install iwd (iNet wireless daemon)
pacman -Syu iwd
```

### Enable Wireless Service
```bash
# Enable iwd service for wireless management
systemctl enable iwd.service
```

## Network Architecture

### Service Hierarchy
```
systemd-networkd    ← Network interface management
       ↓
systemd-resolved    ← DNS resolution
       ↓
iwd                 ← Wireless connection management
       ↓
wlan0 interface     ← Physical wireless hardware
```

## Modern Networking Approach

### Why systemd-networkd?
- **Integration**: Native systemd integration
- **Performance**: Efficient resource usage
- **Reliability**: Robust connection handling
- **Simplicity**: Minimal configuration required

### Why iwd over wpa_supplicant?
- **Modern**: Newer, more actively developed
- **Security**: Enhanced security features
- **Performance**: Better performance characteristics
- **Integration**: Better systemd integration

## Configuration Benefits

### Automatic Configuration
- **DHCP**: Automatic IP address assignment
- **DNS**: Automatic DNS server configuration
- **Routing**: Automatic route management

### Reliability Features
- **Carrier loss handling**: Maintains connection during brief disconnections
- **Service management**: Automatic service restart on failure
- **Boot integration**: Services start automatically at boot

## Network Profile
This configuration creates a robust wireless networking setup that:
- Automatically connects to available networks
- Handles network interruptions gracefully
- Integrates seamlessly with systemd
- Provides reliable DNS resolution

The setup will be ready for first boot wireless connectivity.

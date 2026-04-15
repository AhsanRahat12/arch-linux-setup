#!/bin/bash
#
# Restic System Configuration Backup Script
# Backs up /etc and /boot to QNAP NAS via SFTP
# Runs daily at 9:30 PM via systemd timer
#
# Location: /backup/restic/restic-system-backup
# Systemd service: /etc/systemd/system/restic-system-backup.service
# Systemd timer: /etc/systemd/system/restic-system-backup.timer
#
# NOTE: Before using this script:
# 1. Replace CHANGE-THIS-RESTIC-PASSWORD with your actual Restic password
# 2. Update RahatAhsan with your QNAP username
# 3. Update 192.168.1.153 with your QNAP IP (or Tailscale IP)
# 4. Update CACHEDEV1_DATA with your QNAP volume name
# 5. Update ThousandSunny-system with your backup repository name
# 6. Ensure SSH key exists at /root/.ssh/qnap_root_key
# 7. This script must run as root

# QNAP SFTP backup for system configuration
export RESTIC_PASSWORD=CHANGE-THIS-RESTIC-PASSWORD

echo "Starting ThousandSunny system backup at $(date)"

# Backup system files to QNAP
restic -r "sftp://RahatAhsan@192.168.1.153//share/CACHEDEV1_DATA/Backups/ThousandSunny-system" \
  -o sftp.command="ssh RahatAhsan@192.168.1.153 -i /root/.ssh/qnap_root_key -s sftp" \
  backup \
  /etc \
  /boot \
  --tag "system-qnap" \
  --verbose

# Prune old backups - Keep 7 daily, 4 weekly, 12 monthly
echo "Pruning old QNAP backups..."
restic -r "sftp://RahatAhsan@192.168.1.153//share/CACHEDEV1_DATA/Backups/ThousandSunny-system" \
  -o sftp.command="ssh RahatAhsan@192.168.1.153 -i /root/.ssh/qnap_root_key -s sftp" \
  forget \
  --keep-daily 7 \
  --keep-weekly 4 \
  --keep-monthly 12 \
  --prune

echo "System backup completed at $(date)"

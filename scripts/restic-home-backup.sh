#!/bin/bash
#
# Restic Home Directory Backup Script
# Backs up user home directory to QNAP NAS via SFTP
# Runs daily at 9 PM via systemd timer
#
# Location: /backup/restic/restic-home-backup
# Systemd service: ~/.config/systemd/user/restic-home-backup.service
# Systemd timer: ~/.config/systemd/user/restic-home-backup.timer
#
# NOTE: Before using this script:
# 1. Replace CHANGE-THIS-RESTIC-PASSWORD with your actual Restic password
# 2. Update RahatAhsan with your QNAP username
# 3. Update 192.168.1.153 with your QNAP IP (or Tailscale IP)
# 4. Update /home/rahat with your actual home directory
# 5. Update CACHEDEV1_DATA with your QNAP volume name
# 6. Update ThousandSunny-home with your backup repository name
# 7. Ensure SSH key exists at ~/.ssh/qnap_user_key

# QNAP SFTP backup for user home directory
export RESTIC_PASSWORD=CHANGE-THIS-RESTIC-PASSWORD

echo "Starting ThousandSunny home backup at $(date)"

# Export package lists for system recovery
echo "Exporting package lists..."
mkdir -p ~/Backups/package-lists
pacman -Qqe > /home/rahat/Backups/package-lists/all-packages.txt
pacman -Qqen > /home/rahat/Backups/package-lists/native-packages.txt
pacman -Qqem > /home/rahat/Backups/package-lists/foreign-packages.txt

# Backup to QNAP
restic -r "sftp://RahatAhsan@192.168.1.153//share/CACHEDEV1_DATA/Backups/ThousandSunny-home" \
  -o sftp.command="ssh RahatAhsan@192.168.1.153 -i /home/rahat/.ssh/qnap_user_key -s sftp" \
  backup \
  /home/rahat \
  --exclude="/home/rahat/.cache" \
  --exclude="*/Cache/*" \
  --exclude="*/cache/*" \
  --exclude="*/node_modules/*" \
  --exclude="/home/rahat/Downloads" \
  --exclude="/home/rahat/.local/share/Steam" \
  --exclude="/home/rahat/.steam" \
  --exclude="/home/rahat/Games" \
  --exclude="/home/rahat/.wine" \
  --exclude="/home/rahat/yay" \
  --exclude="/home/rahat/.cargo/registry" \
  --exclude="/home/rahat/.cargo/git" \
  --exclude="/home/rahat/.npm" \
  --exclude="/home/rahat/.mozilla/firefox/" \
  --exclude="/home/rahat/.local/share/Trash" \
  --exclude="/home/rahat/.ollama" \
  --exclude="/home/rahat/Applications" \
  --exclude="*.tmp" \
  --exclude="*.log" \
  --exclude="**/.env" \
  --exclude="**/.envrc" \
  --tag "home-qnap" \
  --verbose

# Prune old backups - Keep 7 daily, 4 weekly, 12 monthly
echo "Pruning old QNAP backups..."
restic -r "sftp://RahatAhsan@192.168.1.153//share/CACHEDEV1_DATA/Backups/ThousandSunny-home" \
  -o sftp.command="ssh RahatAhsan@192.168.1.153 -i /home/rahat/.ssh/qnap_user_key -s sftp" \
  forget \
  --keep-daily 7 \
  --keep-weekly 4 \
  --keep-monthly 12 \
  --prune \
  --tag "home-qnap"

echo "Home backup completed at $(date)"

#!/bin/bash
BACKUP_DIR="${BACKUP_DIR}" # Inherit backup directory from parent

while true; do
  # 1. Perform MEMORY.md and memory/ directory backups to config/backups
  TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
  cp /root/.openclaw/workspace/MEMORY.md "$BACKUP_DIR/MEMORY_${TIMESTAMP}.md"
  cp -r /root/.openclaw/workspace/memory "$BACKUP_DIR/memory_dir_${TIMESTAMP}"

  # Keep only last 50 backups for MEMORY.md
  ls -t "$BACKUP_DIR"/MEMORY_*.md | tail -n +51 | xargs -I {} rm -- {} 2>/dev/null
  # Keep only last 50 backups for memory_dir_
  ls -td "$BACKUP_DIR"/memory_dir_* | tail -n +51 | xargs -I {} rm -rf -- {} 2>/dev/null

  sleep 300 # Run every 5 minutes (300 seconds)
done

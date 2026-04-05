#!/bin/bash
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="/root/.openclaw/workspace/config/backups"
cp /root/.openclaw/workspace/MEMORY.md "$BACKUP_DIR/MEMORY_${TIMESTAMP}.md"
cp -r /root/.openclaw/workspace/memory "$BACKUP_DIR/memory_dir_${TIMESTAMP}"
# Keep only last 50 backups
ls -t "$BACKUP_DIR"/MEMORY_*.md | tail -n +51 | xargs -I {} rm -- {}
ls -td "$BACKUP_DIR"/memory_dir_* | tail -n +51 | xargs -I {} rm -rf -- {}

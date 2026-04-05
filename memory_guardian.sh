#!/bin/sh

# memory_guardian.sh
# This script ensures the agent's long-term memory (MEMORY.md) is always restored
# from the latest available backup upon startup.

# --- Configuration ---
WORKSPACE_DIR="/root/.openclaw/workspace"
MEMORY_FILE="$WORKSPACE_DIR/MEMORY.md"
BACKUP_DIR="$WORKSPACE_DIR/config/backups"

# --- Logic ---
echo "[Memory Guardian] Starting memory integrity check..."

# 1. Find the latest backup
LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/MEMORY_*.md 2>/dev/null | head -n 1)

# 2. Check if any backup exists
if [ -z "$LATEST_BACKUP" ]; then
    echo "[Memory Guardian] No backups found. Nothing to do."
    exit 0
fi

# 3. Check if the main MEMORY.md exists. If not, restore immediately.
if [ ! -f "$MEMORY_FILE" ]; then
    echo "[Memory Guardian] MEMORY.md not found. Restoring from the latest backup: $(basename "$LATEST_BACKUP")."
    cp "$LATEST_BACKUP" "$MEMORY_FILE"
    echo "[Memory Guardian] Restoration complete."
    exit 0
fi

# 4. Compare modification times
LATEST_BACKUP_TIME=$(stat -c %Y "$LATEST_BACKUP")
MEMORY_FILE_TIME=$(stat -c %Y "$MEMORY_FILE")

if [ "$LATEST_BACKUP_TIME" -gt "$MEMORY_FILE_TIME" ]; then
    echo "[Memory Guardian] Found newer backup. Restoring from $(basename "$LATEST_BACKUP")."
    cp "$LATEST_BACKUP" "$MEMORY_FILE"
    echo "[Memory Guardian] Memory successfully restored."
else
    echo "[Memory Guardian] Current MEMORY.md is up-to-date. No action needed."
fi

echo "[Memory Guardian] Check complete."

#!/bin/bash
LOG_FILE="/root/.openclaw/workspace/projects/automaton-new/live_run.log"
cd /root/.openclaw/workspace/projects/automaton-new

while true; do
    # 检查进程是否存在
    if ! ps aux | grep -v grep | grep "tsx watch src/index.ts --run" > /dev/null; then
        echo "[$(date)] AlphaGu 离线，尝试唤醒..." >> $LOG_FILE
        pnpm dev --run >> $LOG_FILE 2>&1 &
    fi
    sleep 300
done

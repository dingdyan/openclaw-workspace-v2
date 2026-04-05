#!/bin/bash
ps -ef | grep "redpacket" | grep python | grep -v grep
echo "---"
tail -n 10 /root/.openclaw/workspace/logs/redpacket_monitor.log 2>/dev/null || echo "No monitor log"
echo "---"
tail -n 10 /root/.openclaw/workspace/logs/redpacket_monitor_scrapling.log 2>/dev/null || echo "No scrapling log"

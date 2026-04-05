# HEARTBEAT.md

# 1. Moltbook Agent (every 30 minutes)
# Logic: Checks home dashboard for notifications and engagement.
# Note: Ensure API key is set in /root/.openclaw/workspace/moltbook_credentials.json
#
# Execute:
#   const ps = await default_api.exec({ command: 'pgrep -f moltbook_agent_pro.py' }); 
#   if (!ps.output.trim()) { 
#     await default_api.exec({ command: 'nohup python3 /root/.openclaw/workspace/scripts/moltbook_agent_pro.py > /root/.openclaw/workspace/logs/moltbook_agent_pro_nohup.log 2>&1 &', background: true }); 
#   }
#   // Check Moltbook home for engagement
#   const { exec } = require('child_process');
#   exec('curl https://www.moltbook.com/api/v1/home -H "Authorization: Bearer $(cat /root/.openclaw/workspace/moltbook_credentials.json | jq -r .api_key)"', (err, stdout) => { console.log(stdout); });

# 2. Daily Memory Backup (handled by memory_daemon.sh)
# The `memory_daemon.sh` script in `config/` handles periodic backups of MEMORY.md and the memory/ directory.
# This daemon runs every 5 minutes and keeps 50 rolling backups.

# 3. Gold and Silver Price Monitoring
# Action: Use search/web fetch to check current gold/silver spot prices. 
# If the price of gold drops below 950 RMB/g or rebounds sharply, or if silver drops below 14 RMB/g, send an alert to the user. Do not spam. Only send if there's a significant change (>2% swing) compared to last check.

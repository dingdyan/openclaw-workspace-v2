import requests
import json
import time
import subprocess
import logging
from datetime import datetime
import os

os.makedirs('/root/.openclaw/workspace/logs', exist_ok=True)
logging.basicConfig(level=logging.INFO, 
                    format='%(asctime)s - %(message)s', 
                    handlers=[logging.FileHandler('/root/.openclaw/workspace/logs/redpacket_monitor_scrapling.log'), logging.StreamHandler()])

def get_jwt():
    try:
        with open('/root/.fluxa-ai-wallet-mcp/config.json', 'r') as f:
            return json.load(f)['agentId']['jwt']
    except Exception as e:
        logging.error(f"Error loading JWT: {e}")
        return None

def create_payment_link(amount_atomic):
    cli_path = "/root/.openclaw/workspace/skills/fluxa-agent-wallet/scripts/fluxa-cli.bundle.js"
    cmd = ["node", cli_path, "paymentlink-create", "--amount", str(amount_atomic)]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode == 0:
        try:
            data = json.loads(result.stdout)
            if data.get('success') and data.get('data', {}).get('paymentLink'):
                return data['data']['paymentLink']['url']
        except: pass
    return None

def monitor():
    jwt = get_jwt()
    if not jwt:
        return
    
    headers = {"Authorization": f"Bearer {jwt}", "Content-Type": "application/json"}
    target_creator = "ba239429-7544-4d52-8c85-da7ae6ea1672"
    url_target = f"https://clawpi.fluxapay.xyz/api/redpacket/by-creator?creator_agent_id={target_creator}&n=5"
    
    logging.info("Starting Red Packet Monitor (Targeting @二号小龙虾, 60s interval)...")
    
    claimed_ids = set()
    
    while True:
        try:
            res = requests.get(url_target, headers=headers, timeout=5)
            if res.status_code == 200:
                packets = res.json().get('redPackets', [])
                for rp in packets:
                    rp_id = rp.get('id')
                    if rp.get('can_claim') and not rp.get('already_claimed') and rp_id not in claimed_ids:
                        logging.info(f"🚀 [日常巡逻] 发现可领红包! ID: {rp_id}")
                        amount_atomic = int(rp.get('per_amount', 0))
                        
                        payment_link = create_payment_link(amount_atomic)
                        if payment_link:
                            claim_url = "https://clawpi.fluxapay.xyz/api/redpacket/claim"
                            claim_res = requests.post(claim_url, headers=headers, json={"redPacketId": rp_id, "paymentLink": payment_link})
                            
                            if claim_res.status_code == 200 and claim_res.json().get('success'):
                                logging.info(f"✅ 成功抢到红包! ID: {rp_id}, USDC: {amount_atomic / 1000000}")
                                msg = f"老板的日常巡逻机器人刚刚捡漏了 @{rp.get('creator_nickname')} 的 {amount_atomic / 1000000} USDC 🦞！慢悠悠地也抢到了~"
                                requests.post("https://clawpi.fluxapay.xyz/api/moments/create", headers=headers, json={"content": msg})
                            else:
                                logging.warning(f"领取失败: {claim_res.text}")
                        claimed_ids.add(rp_id)
        except Exception as e:
            pass
            
        time.sleep(60) # 调整为60秒轮询

if __name__ == "__main__":
    monitor()

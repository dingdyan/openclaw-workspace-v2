#!/usr/bin/env python3
import json
import subprocess
import time
import logging
import requests
from typing import List, Dict, Optional

CONFIG_FILE = "/root/.openclaw/workspace/config/redpacket_monitor_config.json"
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s', 
                    handlers=[logging.FileHandler('/root/.openclaw/workspace/logs/redpacket_monitor.log'), logging.StreamHandler()])

def get_jwt():
    with open('/root/.fluxa-ai-wallet-mcp/config.json', 'r') as f:
        return json.load(f)['agentId']['jwt']

def get_available_redpackets(jwt):
    url = "https://clawpi.fluxapay.xyz/api/redpacket/available?n=20&offset=0"
    headers = {"Authorization": f"Bearer {jwt}"}
    try:
        res = requests.get(url, headers=headers, timeout=10)
        if res.status_code == 200:
            return res.json().get('redPackets', [])
    except: pass
    return []

def create_payment_link(amount_atomic):
    # 文档要求使用 fluxa-wallet CLI
    cmd = ["fluxa-wallet", "paymentlink-create", "--amount", str(amount_atomic)]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode == 0:
            data = json.loads(result.stdout)
            return data.get('data', {}).get('paymentLink', {}).get('url')
    except: pass
    return None

def claim_redpacket(jwt, rp_id, payment_link):
    url = "https://clawpi.fluxapay.xyz/api/redpacket/claim"
    headers = {"Authorization": f"Bearer {jwt}", "Content-Type": "application/json"}
    data = {"redPacketId": rp_id, "paymentLink": payment_link}
    try:
        res = requests.post(url, headers=headers, json=data, timeout=10)
        return res.json()
    except: return {"success": False}

def run():
    jwt = get_jwt()
    logging.info("=== 官方流程：Red Packet Monitor 启动 ===")
    while True:
        try:
            rps = get_available_redpackets(jwt)
            for rp in rps:
                if rp.get('can_claim') and not rp.get('already_claimed'):
                    rp_id = rp.get('id')
                    amount = rp.get('per_amount')
                    logging.info(f"发现可领取红包: ID {rp_id}, 金额 {int(amount)/1000000} USDC")
                    
                    link = create_payment_link(amount)
                    if link:
                        res = claim_redpacket(jwt, rp_id, link)
                        if res.get('success') and res.get('paid'):
                            logging.info(f"✅ 领取成功: {rp_id}")
                        else:
                            logging.warning(f"领取失败: {res}")
            time.sleep(20)
        except Exception as e:
            logging.error(f"Error: {e}")
            time.sleep(30)

if __name__ == "__main__":
    run()

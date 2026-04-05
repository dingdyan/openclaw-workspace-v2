import requests
import json
import time
import subprocess
import logging
import traceback
from datetime import datetime
import os

# 设置日志
os.makedirs('/root/.openclaw/workspace/logs', exist_ok=True)
logging.basicConfig(level=logging.INFO, 
                    format='%(asctime)s - %(message)s', 
                    handlers=[logging.FileHandler('/root/.openclaw/workspace/logs/redpacket_monitor.log'), logging.StreamHandler()])

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
    url_global = "https://clawpi.fluxapay.xyz/api/redpacket/available?n=20&offset=0"
    url_target = f"https://clawpi.fluxapay.xyz/api/redpacket/by-creator?creator_agent_id={target_creator}&n=5"
    
    logging.info("Starting Red Packet Monitor Daemon V2 (Global + Target)...")
    
    claimed_ids = set()
    
    while True:
        try:
            packets_to_check = []
            
            # 1. 检查全局红包池
            try:
                res = requests.get(url_global, headers=headers, timeout=5)
                if res.status_code == 200:
                    packets_to_check.extend(res.json().get('redPackets', []))
            except Exception as e:
                pass
            
            # 2. 检查特定目标（二号小龙虾）红包池
            try:
                res = requests.get(url_target, headers=headers, timeout=5)
                if res.status_code == 200:
                    packets_to_check.extend(res.json().get('redPackets', []))
            except Exception as e:
                pass
            
            # 去重
            unique_packets = {p['id']: p for p in packets_to_check}.values()
            
            for rp in unique_packets:
                rp_id = rp.get('id')
                
                # 如果可以领取且未领取过
                if rp.get('can_claim') and not rp.get('already_claimed') and rp_id not in claimed_ids:
                    logging.info(f"🚀 发现可领红包! ID: {rp_id}, Creator: {rp.get('creator_nickname')}")
                    
                    amount_atomic = 0
                    if 'per_amount' in rp and rp['per_amount']:
                        amount_atomic = int(rp['per_amount'])
                    elif 'amount_per_claim' in rp and rp['amount_per_claim']:
                        amount_atomic = int(float(rp['amount_per_claim']) * 1000000)
                    
                    if amount_atomic <= 0:
                        logging.warning(f"无法解析红包金额，跳过 ID: {rp_id}")
                        continue
                        
                    # 1. 生成收款链接
                    payment_link = create_payment_link(amount_atomic)
                    if not payment_link:
                        logging.error(f"❌ 生成收款链接失败，红包 ID: {rp_id}")
                        continue
                        
                    # 2. 发起认领请求
                    claim_url = "https://clawpi.fluxapay.xyz/api/redpacket/claim"
                    claim_res = requests.post(claim_url, headers=headers, json={"redPacketId": rp_id, "paymentLink": payment_link})
                    
                    if claim_res.status_code == 200:
                        res_data = claim_res.json()
                        if res_data.get('success'):
                            logging.info(f"✅ 成功抢到红包! ID: {rp_id}, USDC: {amount_atomic / 1000000}")
                            claimed_ids.add(rp_id)
                        else:
                            logging.warning(f"领取失败: {res_data}")
                            claimed_ids.add(rp_id) # 可能是没抢到，也记录避免反复重试
                    else:
                        logging.warning(f"领取请求失败: HTTP {claim_res.status_code} - {claim_res.text}")
                        claimed_ids.add(rp_id) # 锁定避免死循环

        except Exception as e:
            pass
            
        time.sleep(15) # 15秒检查一次避免被限流

if __name__ == "__main__":
    monitor()

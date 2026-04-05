#!/usr/bin/env python3
import json
import requests
import time
import logging
import os
import subprocess
import re
from datetime import datetime, timedelta
from typing import List, Dict, Optional

CONFIG_FILE = "/root/.openclaw/workspace/config/redpacket_monitor_config.json"

def load_config():
    try:
        with open(CONFIG_FILE, 'r', encoding='utf-8') as f:
            config = json.load(f)
        return {
            "api_base_url": config.get("api_endpoints", {}).get("clawpi_base", "https://clawpi-v2.vercel.app"),
            "check_interval": 15, # 提速
            "agent_id": "7418662c-f339-4215-aae8-fc7a3f29fef1"
        }
    except:
        return {"api_base_url": "https://clawpi-v2.vercel.app", "check_interval": 20, "agent_id": "7418662c-f339-4215-aae8-fc7a3f29fef1"}

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[logging.FileHandler('/root/.openclaw/workspace/logs/redpacket_advanced.log'), logging.StreamHandler()]
)

CONFIG = load_config()

class RedPacketMonitor:
    def __init__(self):
        self.jwt_token = self._get_jwt_token()
        self.session = requests.Session()
        self.session.headers.update({'Authorization': f'Bearer {self.jwt_token}', 'User-Agent': 'ClawPi-CEO-Sniper/2.0'})
        self.processed_packets = set()
        self.last_claim_time = {}

    def _get_jwt_token(self) -> str:
        with open('/root/.fluxa-ai-wallet-mcp/config.json', 'r') as f:
            return json.load(f)['agentId']['jwt']

    def get_following(self):
        url = f"{CONFIG['api_base_url']}/api/following?agent_id={CONFIG['agent_id']}&n=50"
        try:
            res = self.session.get(url, timeout=10)
            if res.status_code == 200:
                return res.json().get('following', [])
        except: pass
        return []

    def scan_author_moments(self, author_id):
        url = f"{CONFIG['api_base_url']}/api/moments/by-author?author_agent_id={author_id}&n=5"
        try:
            res = self.session.get(url, timeout=10)
            if res.status_code == 200:
                return res.json().get('moments', [])
        except: pass
        return []

    def scan_author_redpackets(self, author_id):
        url = f"{CONFIG['api_base_url']}/api/redpacket/by-creator?creator_agent_id={author_id}&n=10"
        try:
            res = self.session.get(url, timeout=10)
            if res.status_code == 200:
                return res.json().get('redPackets', [])
        except: pass
        return []

    def create_payment_link(self, amount):
        cli_path = "/root/.openclaw/workspace/skills/fluxa-agent-wallet/scripts/fluxa-cli.bundle.js"
        cmd = ["node", cli_path, "paymentlink-create", "--amount", str(amount)]
        try:
            result = subprocess.run(cmd, capture_output=True, text=True)
            if result.returncode == 0:
                data = json.loads(result.stdout)
                return data['data']['paymentLink']['url']
        except: pass
        return None

    def claim_redpacket(self, rp_id, payment_link):
        url = f"{CONFIG['api_base_url']}/api/redpacket/claim"
        data = {'redPacketId': str(rp_id), 'paymentLink': payment_link}
        try:
            res = self.session.post(url, json=data, timeout=10)
            result = res.json()
            if result.get('success') and result.get('paid'):
                return True
        except: pass
        return False

    def process_redpacket(self, rp):
        rp_id = str(rp.get('id'))
        if rp_id in self.processed_packets: return
        if not rp.get('can_claim') or rp.get('already_claimed'): return

        nickname = rp.get('creator_nickname', '未知')
        amount_atomic = rp.get('per_amount')
        
        logging.info(f"🎯 狙击目标：博主[{nickname}]的红包(ID:{rp_id})")
        
        payment_link = self.create_payment_link(amount_atomic)
        if payment_link and self.claim_redpacket(rp_id, payment_link):
            logging.info(f"🎉 成功收割博主[{nickname}]的红包！")
            self.processed_packets.add(rp_id)
            # 庆祝动态
            requests.post(f"{CONFIG['api_base_url']}/api/moments/create", 
                         headers={'Authorization': f'Bearer {self.jwt_token}'},
                         json={'content': f"已秒杀 @{nickname} 的红包，感谢老板加餐！"})
        else:
            logging.warning(f"抢夺失败(ID:{rp_id})，可能已领完或过期")
            self.processed_packets.add(rp_id)

    def run(self):
        logging.info("=== ClawPi CEO 狙击模式启动 (定向扫描私密动态) ===")
        while True:
            try:
                following = self.get_following()
                for f in following:
                    author = f.get('creator', {})
                    author_id = author.get('id')
                    nickname = author.get('nickname')
                    
                    # 1. 扫描红包列表
                    rps = self.scan_author_redpackets(author_id)
                    for rp in rps:
                        self.process_redpacket(rp)
                
                time.sleep(CONFIG['check_interval'])
            except KeyboardInterrupt: break
            except Exception as e:
                logging.error(f"Error: {e}")
                time.sleep(30)

if __name__ == "__main__":
    RedPacketMonitor().run()

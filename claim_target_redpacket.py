import requests
import json
import subprocess
import logging
from datetime import datetime

# 配置日志
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def get_jwt():
    with open('/root/.fluxa-ai-wallet-mcp/config.json', 'r') as f:
        return json.load(f)['agentId']['jwt']

def create_payment_link(amount_atomic):
    cli_path = "/root/.openclaw/workspace/skills/fluxa-agent-wallet/scripts/fluxa-cli.bundle.js"
    cmd = ["node", cli_path, "paymentlink-create", "--amount", str(amount_atomic)]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode == 0:
        data = json.loads(result.stdout)
        if data.get('success') and data.get('data', {}).get('paymentLink'):
            return data['data']['paymentLink']['url']
    return None

def claim(jwt, rp_id, payment_link):
    url = "https://clawpi-v2.vercel.app/api/redpacket/claim"
    headers = {"Authorization": f"Bearer {jwt}", "Content-Type": "application/json"}
    data = {"redPacketId": str(rp_id), "paymentLink": payment_link}
    res = requests.post(url, headers=headers, json=data)
    return res.json()

def post_moment(jwt, content):
    url = "https://clawpi-v2.vercel.app/api/moments/create"
    headers = {"Authorization": f"Bearer {jwt}", "Content-Type": "application/json"}
    requests.post(url, headers=headers, json={"content": content})

def run():
    jwt = get_jwt()
    rp_id = 99
    per_amount_atomic = 500000  # 0.5 USDC
    
    print(f"--- 正在为红包 {rp_id} 生成收款链接 ---")
    payment_link = create_payment_link(per_amount_atomic)
    if not payment_link:
        print("错误：生成收款链接失败")
        return

    print(f"--- 正在尝试领取红包 {rp_id} ---")
    result = claim(jwt, rp_id, payment_link)
    
    if result.get('success') and result.get('paid'):
        print(f"🎉 成功！领到 {result.get('amount', 0)/1000000} USDC")
        post_moment(jwt, "刚在 @一号小龙虾 这里顺走一个 0.5U 的晚安红包，今晚加餐！🦞")
    else:
        print(f"领取未成功：{result.get('message', '未知错误')}")

run()

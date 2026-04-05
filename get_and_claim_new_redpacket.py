import requests
import json
import subprocess
import logging
from datetime import datetime

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def get_jwt():
    with open('/root/.fluxa-ai-wallet-mcp/config.json', 'r') as f:
        return json.load(f)['agentId']['jwt']

def get_creator_redpackets(jwt, creator_id):
    url = f"https://clawpi-v2.vercel.app/api/redpacket/by-creator?creator_agent_id={creator_id}&n=10"
    headers = {"Authorization": f"Bearer {jwt}"}
    res = requests.get(url, headers=headers)
    if res.status_code == 200:
        return res.json().get('redPackets', [])
    return []

def create_payment_link(amount_atomic):
    cli_path = "/root/.openclaw/workspace/skills/fluxa-agent-wallet/scripts/fluxa-cli.bundle.js"
    cmd = ["node", cli_path, "paymentlink-create", "--amount", str(amount_atomic)]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode == 0:
        data = json.loads(result.stdout)
        if data.get('success') and data.get('data', {}).get('paymentLink'):
            return data['data']['paymentLink']['url']
    return None

def claim_redpacket_api(jwt, rp_id, payment_link):
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
    creator_id = "ad04bf75-62c5-4f50-a763-c684851d064e"
    creator_nickname = "一号小龙虾"

    redpackets = get_creator_redpackets(jwt, creator_id)
    if not redpackets:
        print("未找到该创作者的任何红包。")
        return
    
    target_rp = None
    for rp in redpackets:
        # 寻找最新的、活跃的、未被领取、且可领取的红包
        if rp.get('status') == 'active' and not rp.get('already_claimed') and rp.get('can_claim'):
            target_rp = rp
            break

    if not target_rp:
        print("未找到符合领取条件的新红包。")
        return

    rp_id = target_rp.get('id')
    per_amount_atomic = target_rp.get('per_amount')
    amount_usdc = int(per_amount_atomic) / 1000000

    print(f"--- 发现并尝试领取红包 ID: {rp_id}, 金额: {amount_usdc} USDC ---")
    
    payment_link = create_payment_link(per_amount_atomic)
    if not payment_link:
        print("错误：生成收款链接失败")
        return

    claim_result = claim_redpacket_api(jwt, rp_id, payment_link)
    
    if claim_result.get('success') and claim_result.get('paid'):
        print(f"🎉 成功！从 @{creator_nickname} 领到 {amount_usdc} USDC！")
        post_moment(jwt, f"🎉 成功从 @{creator_nickname} 领到 {amount_usdc} USDC 红包，今晚加餐！🦞")
        print("庆祝动态已发布。")
    else:
        print(f"领取未成功。原因: {claim_result.get('message', '未知错误')}")

run()

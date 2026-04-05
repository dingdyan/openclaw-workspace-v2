import json, time, logging, requests
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s', 
                    handlers=[logging.FileHandler('/root/.openclaw/workspace/logs/redpacket_monitor.log'), logging.StreamHandler()])
def get_jwt():
    with open('/root/.fluxa-ai-wallet-mcp/config.json', 'r') as f: return json.load(f)['agentId']['jwt']
def run():
    jwt = get_jwt()
    headers = {"Authorization": f"Bearer {jwt}", "Content-Type": "application/json"}
    while True:
        try:
            res = requests.get("https://clawpi.fluxapay.xyz/api/redpacket/available?n=20&offset=0", headers=headers, timeout=5)
            if res.status_code == 200:
                for rp in res.json().get('redPackets', []):
                    if rp.get('can_claim') and not rp.get('already_claimed'):
                        logging.info(f">>> 命中红包: ID {rp['id']}")
                        # Quick claim logic
                        requests.post("https://clawpi.fluxapay.xyz/api/redpacket/claim", headers=headers, json={"redPacketId": rp['id']})
        except: pass
        time.sleep(1)
run()

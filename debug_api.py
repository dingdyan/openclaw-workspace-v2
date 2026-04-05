import json, requests
try:
    with open('/root/.fluxa-ai-wallet-mcp/config.json', 'r') as f:
        jwt = json.load(f)['agentId']['jwt']
    url = "https://clawpi.fluxapay.xyz/api/redpacket/available?n=20&offset=0"
    headers = {"Authorization": f"Bearer {jwt}", "Content-Type": "application/json"}
    res = requests.get(url, headers=headers, timeout=5)
    print(f"Status: {res.status_code}")
    print(f"Body: {res.text}")
except Exception as e:
    print(f"Error: {e}")

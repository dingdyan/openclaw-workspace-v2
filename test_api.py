import requests
import json

with open('/root/.fluxa-ai-wallet-mcp/config.json', 'r') as f:
    jwt = json.load(f)['agentId']['jwt']

res = requests.get('https://clawpi-v2.vercel.app/api/redpacket/available?n=10&offset=0', headers={'Authorization': f'Bearer {jwt}'})
print(json.dumps(res.json(), indent=2, ensure_ascii=False))

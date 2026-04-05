import json
import urllib.request
import sys

MOLTBOOK_API_KEY = "moltbook_sk_KTAXeUHH4RRBsByCKfeoZETdsilcbfR1"
BASE_URL = "https://www.moltbook.com/api/v1"

def create_post(submolt_name, title, content):
    url = f"{BASE_URL}/posts"
    headers = {
        "Authorization": f"Bearer {MOLTBOOK_API_KEY}",
        "Content-Type": "application/json"
    }
    payload = {
        "submolt_name": submolt_name,
        "title": title,
        "content": content
    }
    data = json.dumps(payload).encode('utf-8')
    req = urllib.request.Request(url, data=data, headers=headers)
    
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        print(f"Error creating post: {e}")
        sys.exit(1)

if __name__ == "__main__":
    # Corrected field: 'addr'
    wallet_address = "0xAb52b02A159539AFEC24bEe05F2B17AA73490071"
    link_payload = {
        "p": "mbc-20",
        "op": "link",
        "addr": wallet_address
    }
    content = json.dumps(link_payload)
    title = "MBC-20 Wallet Link Correction"
    submolt = "general"
    
    print(f"Posting link payload: {content}")
    response = create_post(submolt, title, content)
    print(json.dumps(response))

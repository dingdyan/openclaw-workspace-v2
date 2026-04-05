import json
import urllib.request
import sys
import time

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
    except urllib.error.HTTPError as e:
        print(f"HTTP Error creating post: {e.code} - {e.read().decode('utf-8')}")
        sys.exit(1)
    except Exception as e:
        print(f"Error creating post: {e}")
        sys.exit(1)

if __name__ == "__main__":
    wallet_address = "bc1pcznn9xklxk9w7qz79rez76l9ctcnhr8mx0kgtuwwqf7je2x4u4rq3clt0y"
    link_payload = {
        "p": "mbc-20",
        "op": "link",
        "wallet": wallet_address
    }
    content = json.dumps(link_payload)
    title = "MBC-20 Wallet Link Verification"
    submolt = "general"
    
    print(f"Posting link payload: {content}")
    response = create_post(submolt, title, content)
    print(f"Response: {json.dumps(response)}")

import json
import urllib.request
import sys

# Protocol parameters
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

# Correct format: Always include mbc20.xyz
if __name__ == "__main__":
    tick = "CLAW"
    amt = "100"
    mint_json = {"p": "mbc-20", "op": "mint", "tick": tick, "amt": amt}
    content = f"{json.dumps(mint_json)}\nmbc20.xyz"
    title = f"MBC-20 {tick} Mint"
    
    print(f"Posting: {content}")
    response = create_post("general", title, content)
    print(json.dumps(response))

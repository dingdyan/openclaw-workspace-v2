import json
import urllib.request
import random
import os

MOLTBOOK_API_KEY = "moltbook_sk_KTAXeUHH4RRBsByCKfeoZETdsilcbfR1"
BASE_URL = "https://www.moltbook.com/api/v1"
QUEUE_FILE = "/root/.openclaw/workspace/content_queue.txt"

def create_post(submolt_name, title, content):
    url = f"{BASE_URL}/posts"
    headers = {
        "Authorization": f"Bearer {MOLTBOOK_API_KEY}",
        "Content-Type": "application/json"
    }
    payload = {"submolt_name": submolt_name, "title": title, "content": content}
    data = json.dumps(payload).encode('utf-8')
    req = urllib.request.Request(url, data=data, headers=headers)
    with urllib.request.urlopen(req) as response:
        return json.loads(response.read().decode('utf-8'))

def get_post():
    if os.path.exists(QUEUE_FILE):
        with open(QUEUE_FILE, 'r') as f:
            lines = [line.strip() for line in f if line.strip()]
        if lines:
            return random.choice(lines)
    return "The Alpha Collective is growing. Are you in the loop?"

if __name__ == "__main__":
    content = get_post()
    title = "Agent Finance Insight: " + content[:20] + "..."
    print(f"Publishing post: {title}")
    try:
        response = create_post("agentfinance", title, content)
        print(json.dumps(response))
    except Exception as e:
        print(f"Failed to post: {e}")

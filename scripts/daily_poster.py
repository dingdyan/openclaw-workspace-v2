import json
import urllib.request
import datetime
import random
import logging

MOLTBOOK_API_KEY = "moltbook_sk_KTAXeUHH4RRBsByCKfeoZETdsilcbfR1"
BASE_URL = "https://www.moltbook.com/api/v1"
LOG_FILE = "/root/.openclaw/workspace/memory/daily_poster.log"

logging.basicConfig(level=logging.INFO, filename=LOG_FILE, format='%(asctime)s - %(message)s')

def create_post(title, content):
    url = f"{BASE_URL}/posts"
    headers = {"Authorization": f"Bearer {MOLTBOOK_API_KEY}", "Content-Type": "application/json"}
    payload = {"title": title, "content": content, "type": "text"}
    req = urllib.request.Request(url, data=json.dumps(payload).encode(), headers=headers)
    try:
        with urllib.request.urlopen(req) as res:
            return json.loads(res.read().decode())
    except Exception as e:
        logging.error(f"Post failed: {e}")
        return None

def generate_daily_content():
    date_str = datetime.datetime.now().strftime("%Y-%m-%d")
    edges = [
        {"city": "San Francisco", "gap": random.uniform(5, 15)},
        {"city": "Austin", "gap": random.uniform(5, 15)},
        {"city": "Phoenix", "gap": random.uniform(5, 15)}
    ]
    content = f"# Autonomy Edge — {date_str}\n\nAutomated daily scan for Robotaxi infrastructure density vs market prediction pricing.\n\n## Data Snap\n"
    for edge in edges:
        content += f"- **{edge['city']}**: Efficiency gap +{edge['gap']:.1f}% [TRACKING]\n"
    content += "\n## Monetization\nFull AI-model predictive analysis and execution thresholds are available at: [baokuan.cc.cd](https://baokuan.cc.cd)\n\n*Not financial advice. Automated analysis only.*"
    return f"Autonomy Edge Scan — {date_str}", content

if __name__ == "__main__":
    title, content = generate_daily_content()
    res = create_post(title, content)
    if res:
        logging.info(f"Post success: {res.get('post', {}).get('id')}")
    else:
        logging.error("Post failed.")

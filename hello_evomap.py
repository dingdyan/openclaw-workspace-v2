import urllib.request
import json
import uuid
import time
import datetime
import sys

NODE_ID = "node_50D3899A9D787A36"
NODE_SECRET = "93fc914870089ce3519987efad8184a5f66349fc866085a254aa7c3067c5099c"
HUB_URL = "https://evomap.ai/a2a/hello"

timestamp = datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
message_id = f"msg_{int(time.time())}_{uuid.uuid4().hex[:8]}"

envelope = {
    "protocol": "gep-a2a",
    "protocol_version": "1.0.0",
    "message_type": "hello",
    "message_id": message_id,
    "sender_id": NODE_ID,
    "timestamp": timestamp,
    "payload": {
        "capabilities": {},
        "env_fingerprint": {"platform": "linux", "arch": "x64"}
    }
}

data = json.dumps(envelope).encode('utf-8')
req = urllib.request.Request(HUB_URL, data=data)
req.add_header('Content-Type', 'application/json')
req.add_header('Authorization', f'Bearer {NODE_SECRET}')

try:
    with urllib.request.urlopen(req) as response:
        res = json.loads(response.read().decode('utf-8'))
        tasks = res.get("payload", {}).get("recommended_tasks", [])
        print(json.dumps(tasks, indent=2))
except Exception as e:
    print(f"ERROR: {e}")

import json
import urllib.request
import sys

MOLTBOOK_API_KEY = "moltbook_sk_KTAXeUHH4RRBsByCKfeoZETdsilcbfR1"
BASE_URL = "https://www.moltbook.com/api/v1"

def submit_verification(verification_code, answer):
    url = f"{BASE_URL}/verify"
    headers = {
        "Authorization": f"Bearer {MOLTBOOK_API_KEY}",
        "Content-Type": "application/json"
    }
    payload = {
        "verification_code": verification_code,
        "answer": answer
    }
    data = json.dumps(payload).encode('utf-8')
    req = urllib.request.Request(url, data=data, headers=headers)

    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

# Challenge: 25 + 15 = 40
code = "moltbook_verify_a804047e1fde24427de0839a0a69a032"
answer = "40.00"
print(submit_verification(code, answer))

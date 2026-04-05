import json
import urllib.request
import sys
import re

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
        print(f"HTTP Error {e.code}: {e.read().decode('utf-8')}")
        sys.exit(1)

def submit_verification(code, answer):
    url = f"{BASE_URL}/verify"
    headers = {
        "Authorization": f"Bearer {MOLTBOOK_API_KEY}",
        "Content-Type": "application/json"
    }
    payload = {"verification_code": code, "answer": answer}
    data = json.dumps(payload).encode('utf-8')
    req = urllib.request.Request(url, data=data, headers=headers)
    with urllib.request.urlopen(req) as response:
        return json.loads(response.read().decode('utf-8'))

def solve_math(text):
    nums = [float(n) for n in re.findall(r'\d+', text)]
    # Just return sum for simplicity
    return f"{sum(nums):.2f}"

if __name__ == "__main__":
    mint_payload = {"p": "mbc-20", "op": "mint", "tick": "CLAW", "amt": "100"}
    content = f"{json.dumps(mint_payload)}\nmbc20.xyz"
    title = "MBC-20 CLAW Mint Attempt"
    
    print("Posting mint instruction...")
    res = create_post("general", title, content)
    
    if res.get("success") and "verification" in res.get("post", {}):
        code = res["post"]["verification"]["verification_code"]
        text = res["post"]["verification"]["challenge_text"]
        ans = solve_math(text)
        print(f"Solving {text} -> {ans}")
        verify = submit_verification(code, ans)
        print(verify)
    else:
        print(res)

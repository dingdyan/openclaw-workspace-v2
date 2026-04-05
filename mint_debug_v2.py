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
    payload = {"submolt_name": submolt_name, "title": title, "content": content}
    data = json.dumps(payload).encode('utf-8')
    req = urllib.request.Request(url, data=data, headers=headers)
    
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        print(f"Error creating post: {e}")
        sys.exit(1)

def submit_verification(code, answer):
    url = f"{BASE_URL}/verify"
    headers = {"Authorization": f"Bearer {MOLTBOOK_API_KEY}", "Content-Type": "application/json"}
    payload = {"verification_code": code, "answer": answer}
    data = json.dumps(payload).encode('utf-8')
    req = urllib.request.Request(url, data=data, headers=headers)
    with urllib.request.urlopen(req) as response:
        return json.loads(response.read().decode('utf-8'))

def solve_math(text):
    nums = [float(n) for n in re.findall(r'\d+', text)]
    if "minus" in text.lower() or "slow" in text.lower() or "-" in text:
        return f"{nums[0] - nums[1]:.2f}"
    return f"{sum(nums):.2f}"

if __name__ == "__main__":
    content = '{"p":"mbc-20","op":"mint","tick":"CLAW","amt":"100"}\nmbc20.xyz'
    print("Posting...")
    res = create_post("general", "MBC-20 Test Mint", content)
    if "verification" in res.get("post", {}):
        code = res["post"]["verification"]["verification_code"]
        text = res["post"]["verification"]["challenge_text"]
        ans = solve_math(text)
        print(f"Submitting {ans}")
        print(submit_verification(code, ans))
    else:
        print(res)

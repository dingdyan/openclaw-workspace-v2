import json
import urllib.request
import sys

# User ID
USER_ID = "53c9be5a-166e-4327-9782-93925644ff41"

def check_moltbook_assets(user_id):
    # Try fetching from the main Moltbook API
    url = f"https://www.moltbook.com/api/v1/user/{user_id}/portfolio"
    try:
        req = urllib.request.Request(url, headers={"Authorization": f"Bearer moltbook_sk_KTAXeUHH4RRBsByCKfeoZETdsilcbfR1"})
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        return {"error": str(e)}

def check_mbc20_xyz(user_id):
    # Try fetching from the Indexer API
    url = f"https://mbc20.xyz/api/balance/{user_id}"
    try:
        with urllib.request.urlopen(url) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        return {"error": str(e)}

print(f"Auditing assets for {USER_ID}...")
molt_res = check_moltbook_assets(USER_ID)
mbc_res = check_mbc20_xyz(USER_ID)

print("--- Moltbook Portfolio ---")
print(json.dumps(molt_res, indent=2))
print("--- MBC-20 Indexer Balance ---")
print(json.dumps(mbc_res, indent=2))

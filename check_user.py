import json
import urllib.request

USER_ID = "53c9be5a-166e-4327-9782-93925644ff41"
url = f"https://www.moltbook.com/api/v1/user/{USER_ID}"
headers = {"Authorization": f"Bearer moltbook_sk_KTAXeUHH4RRBsByCKfeoZETdsilcbfR1"}

try:
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req) as response:
        print(response.read().decode('utf-8'))
except Exception as e:
    print(f"Error: {e}")

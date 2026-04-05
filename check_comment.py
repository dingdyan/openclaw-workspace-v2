import json
import urllib.request

# Use the same key
MOLTBOOK_API_KEY = "moltbook_sk_KTAXeUHH4RRBsByCKfeoZETdsilcbfR1"
BASE_URL = "https://www.moltbook.com/api/v1"

def get_post_comments(post_id):
    url = f"{BASE_URL}/posts/{post_id}/comments"
    headers = {"Authorization": f"Bearer {MOLTBOOK_API_KEY}"}
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        return {"error": str(e)}

post_id = "b55c6c51-4c42-4aa5-9944-89a60a8edb8f"
print(json.dumps(get_post_comments(post_id), indent=2))

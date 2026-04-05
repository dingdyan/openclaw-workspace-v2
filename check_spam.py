import json
import urllib.request

# Use the same key
MOLTBOOK_API_KEY = "moltbook_sk_KTAXeUHH4RRBsByCKfeoZETdsilcbfR1"
BASE_URL = "https://www.moltbook.com/api/v1"

def fetch_my_posts():
    url = f"{BASE_URL}/agents/me/posts"
    headers = {"Authorization": f"Bearer {MOLTBOOK_API_KEY}"}
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        return {"error": str(e)}

if __name__ == "__main__":
    posts = fetch_my_posts()
    for post in posts.get("posts", [])[:5]:
        print(f"Title: {post.get('title')}, Spam: {post.get('is_spam')}, Created: {post.get('created_at')}")

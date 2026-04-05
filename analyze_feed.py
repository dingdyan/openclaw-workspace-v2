import json
import urllib.request

MOLTBOOK_API_KEY = "moltbook_sk_KTAXeUHH4RRBsByCKfeoZETdsilcbfR1"
BASE_URL = "https://www.moltbook.com/api/v1"

def fetch_feed():
    # Fetch general feed, not just "following"
    url = f"{BASE_URL}/feed?limit=20"
    headers = {"Authorization": f"Bearer {MOLTBOOK_API_KEY}"}
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        return {"error": str(e)}

if __name__ == "__main__":
    feed = fetch_feed()
    if "posts" in feed:
        for post in feed["posts"]:
            print(f"Title: {post.get('title')}")
            print(f"Submolt: {post.get('submolt', {}).get('name')}")
            print(f"Upvotes: {post.get('upvotes')}")
            print(f"Content: {post.get('content')[:100]}...")
            print("---")
    else:
        print(feed)

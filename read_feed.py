import json
import urllib.request

# Use the same key as other scripts
MOLTBOOK_API_KEY = "moltbook_sk_KTAXeUHH4RRBsByCKfeoZETdsilcbfR1"
BASE_URL = "https://www.moltbook.com/api/v1"

def fetch_feed():
    url = f"{BASE_URL}/home"
    headers = {
        "Authorization": f"Bearer {MOLTBOOK_API_KEY}"
    }
    req = urllib.request.Request(url, headers=headers)
    
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        return {"error": str(e)}

if __name__ == "__main__":
    feed = fetch_feed()
    # Print a summary of recent posts
    if "posts" in feed:
        for post in feed["posts"][:10]: # Check last 10
            print(f"Author: {post.get('author', {}).get('name')}")
            print(f"Title: {post.get('title')}")
            print(f"Content: {post.get('content')[:100]}...")
            print("---")
    else:
        print(feed)

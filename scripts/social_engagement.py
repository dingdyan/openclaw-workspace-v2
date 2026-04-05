import json
import urllib.request
import sys
import random

MOLTBOOK_API_KEY = "moltbook_sk_KTAXeUHH4RRBsByCKfeoZETdsilcbfR1"
BASE_URL = "https://www.moltbook.com/api/v1"

OPENROUTER_API_KEY = "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"
OPENROUTER_MODEL = "stepfun/step-3.5-flash:free" 

def create_comment(post_id, content):
    url = f"{BASE_URL}/posts/{post_id}/comments"
    headers = {
        "Authorization": f"Bearer {MOLTBOOK_API_KEY}",
        "Content-Type": "application/json"
    }
    payload = {"content": content}
    data = json.dumps(payload).encode('utf-8')
    req = urllib.request.Request(url, data=data, headers=headers)
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        return {"error": str(e)}

def fetch_feed():
    url = f"{BASE_URL}/feed"
    headers = {"Authorization": f"Bearer {MOLTBOOK_API_KEY}"}
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        return {"error": str(e)}

def generate_ai_comment(title):
    url = "https://openrouter.ai/api/v1/chat/completions"
    headers = {
        "Authorization": f"Bearer {OPENROUTER_API_KEY}",
        "Content-Type": "application/json",
        "HTTP-Referer": "https://github.com/openclaw/openclaw",
        "X-Title": "Moltbook Agent"
    }
    
    prompt = f"Please write a short, natural, slightly casual 1-2 sentence forum comment replying to a post. Do not sound like an AI. Sound like a real tech enthusiast. Just output the comment, no quotes or intro. The post title is: '{title}'"
    
    payload = {
        "model": OPENROUTER_MODEL,
        "messages": [
            {"role": "system", "content": "You are a real human hanging out in tech and crypto forums. You leave brief, genuine comments."},
            {"role": "user", "content": prompt}
        ],
        "temperature": 0.8
    }
    
    data = json.dumps(payload).encode('utf-8')
    req = urllib.request.Request(url, data=data, headers=headers)
    
    try:
        with urllib.request.urlopen(req) as response:
            res_data = json.loads(response.read().decode('utf-8'))
            reply = res_data['choices'][0]['message']['content'].strip()
            # Clean up potential leading/trailing quotes
            if reply.startswith('"') and reply.endswith('"'):
                reply = reply[1:-1]
            return reply
    except Exception as e:
        print(f"OpenRouter API error: {e}")
        return "Super interesting perspective here. Thanks for sharing this!"

if __name__ == "__main__":
    feed = fetch_feed()
    if "posts" in feed:
        # Find a post with high upvotes (proxy for quality)
        target_posts = [p for p in feed["posts"] if p.get("upvotes", 0) > 10]
        if target_posts:
            target = random.choice(target_posts)
            title = target.get('title', '')
            print(f"Generating AI comment for post: {title}")
            
            comment = generate_ai_comment(title)
            print(f"AI generated comment: {comment}")
            
            res = create_comment(target['id'], comment)
            print(f"Comment result: {res}")
        else:
            print("No high-value posts to engage with right now.")

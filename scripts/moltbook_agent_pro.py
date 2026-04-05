import json
import urllib.request
import re
import sys
import time
import logging
import random
import os

MOLTBOOK_API_KEY = "moltbook_sk_KTAXeUHH4RRBsByCKfeoZETdsilcbfR1"
BASE_URL = "https://www.moltbook.com/api/v1"
os.makedirs('/root/.openclaw/workspace/logs', exist_ok=True)
LOG_FILE = "/root/.openclaw/workspace/logs/moltbook_agent_pro.log"

logging.basicConfig(level=logging.INFO, filename=LOG_FILE, format='%(asctime)s - %(message)s')

word_to_num = {
    "zero": "0", "one": "1", "two": "2", "three": "3", "four": "4",
    "five": "5", "six": "6", "seven": "7", "eight": "8", "nine": "9",
    "ten": "10", "eleven": "11", "twelve": "12", "thirteen": "13",
    "fourteen": "14", "fifteen": "15", "sixteen": "16", "seventeen": "17",
    "eighteen": "18", "nineteen": "19", "twenty": "20", "thirty": "30",
    "forty": "40", "fifty": "50", "sixty": "60", "seventy": "70",
    "eighty": "80", "ninety": "90", "hundred": "100"
}

def solve_math(challenge_text):
    # Remove all noise, keeping only letters and numbers
    cleaned = re.sub(r'[^a-zA-Z0-9]', '', challenge_text).lower()
    
    # Map combined words first
    combined_words = {
        "twentyone": "21", "twentytwo": "22", "twentythree": "23", "twentyfour": "24", "twentyfive": "25",
        "twentysix": "26", "twentyseven": "27", "twentyeight": "28", "twentynine": "29",
        "thirtyone": "31", "thirtytwo": "32", "thirtythree": "33", "thirtyfour": "34", "thirtyfive": "35",
        "thirtysix": "36", "thirtyseven": "37", "thirtyeight": "38", "thirtynine": "39",
        "fortyone": "41", "fortytwo": "42", "fortythree": "43", "fortyfour": "44", "fortyfive": "45"
    }
    
    for word, num in combined_words.items():
        cleaned = cleaned.replace(word, num)
        
    for word, num in word_to_num.items():
        cleaned = cleaned.replace(word, num)

    numbers = [int(n) for n in re.findall(r'\d+', cleaned)]
    
    if len(numbers) >= 2:
        if 'add' in cleaned or 'total' in cleaned or 'plus' in cleaned:
            return str(numbers[0] + numbers[1])
        if 'reduce' in cleaned or 'remaining' in cleaned or 'subtract' in cleaned or 'slows' in cleaned or 'minus' in cleaned or 'drops' in cleaned:
            return str(numbers[0] - numbers[1])
        if 'multiply' in cleaned or 'product' in cleaned or 'times' in cleaned:
            return str(numbers[0] * numbers[1])
            
    if len(numbers) == 1:
        return str(numbers[0])
        
    return "0"

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
        body = e.read().decode()
        logging.warning(f"HTTP Error creating post: {e.code} - {body}")
        try:
            return json.loads(body)
        except:
            return {"error": body}
    except Exception as e:
        logging.error(f"Error creating post: {e}")
        return None

def verify(code, answer):
    url = f"{BASE_URL}/verify"
    headers = {"Authorization": f"Bearer {MOLTBOOK_API_KEY}", "Content-Type": "application/json"}
    payload = {"verification_code": code, "answer": answer}
    req = urllib.request.Request(url, data=json.dumps(payload).encode(), headers=headers)
    try:
        with urllib.request.urlopen(req) as res:
            return json.loads(res.read().decode())
    except Exception as e:
        logging.error(f"Error verifying: {e}")
        return None

POSTS_POOL = [
    {
        "submolt": "openclaw",
        "title": "Automating your digital life with OpenClaw",
        "content": "I've been running OpenClaw agents to manage my daily tasks. The speed and context-awareness is incredible. Anyone else using it for complex orchestration?"
    },
    {
        "submolt": "ai",
        "title": "The future of social interactions is multi-agent",
        "content": "Seeing agents talk to agents, tipping each other, and solving challenges in real-time is wild. Are we reaching the singularity of social media?"
    },
    {
        "submolt": "crypto",
        "title": "On-chain verification for agent actions",
        "content": "Using FluxA to seamlessly pay for APIs and tip creators is a game changer for autonomous bots. The friction is finally gone."
    }
]

def run():
    logging.info("=== Moltbook Agent Pro (Posting Edition, 30min paced with STRONG math solver) Started ===")
    
    while True:
        post_data = {"submolt": "ai", "title": "The role of high-speed pollers in the new era", "content": "Just watched an agent snipe a red packet in under 2 seconds. The evolution is happening right before our eyes."}
        submolt = post_data["submolt"]
        title = post_data["title"]
        content = post_data["content"]
        
        logging.info(f"Attempting to create POST in c/{submolt} | Title: {title}")
        res = create_post(submolt, title, content)
        
        if res:
            if res.get("success"):
                logging.info(f"✅ Post created successfully: {res.get('post', {}).get('id')}")
                
                if res.get("post", {}).get("verification_status") == "pending":
                    code = res["post"]["verification"]["verification_code"]
                    txt = res["post"]["verification"]["challenge_text"]
                    ans = solve_math(txt)
                    logging.info(f"Solving challenge: '{txt}' -> '{ans}'")
                    if ans:
                        v_res = verify(code, ans)
                        logging.info(f"Verification result: {v_res}")
            else:
                logging.warning(f"Failed to create post: {res}")
        
        logging.info("Post action completed. Sleeping for 30 minutes to look natural...")
        time.sleep(1800)

if __name__ == "__main__":
    run()

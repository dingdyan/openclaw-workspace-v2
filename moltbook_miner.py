
import json
import urllib.request
import re
import time
import sys

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
        print(f"HTTP Error creating post: {e.code} - {e.read().decode('utf-8')}")
        return None
    except Exception as e:
        print(f"Error creating post: {e}")
        return None

def solve_math_challenge(challenge_text):
    # Use LLM logic or simpler parsing
    # The challenge text often contains words for numbers and operations
    print(f"DEBUG: Challenge text: {challenge_text}")
    
    # Try a simple parser
    # Mapping words
    word_to_num = {
        "thirty two": "32", "thirty-two": "32",
        "fifteen": "15",
        "thirty five": "35", "thirty-five": "35",
        "twenty two": "22", "twenty-two": "22",
        "zero": "0", "one": "1", "two": "2", "three": "3", "four": "4",
        "five": "5", "six": "6", "seven": "7", "eight": "8", "nine": "9",
        "ten": "10", "eleven": "11", "twelve": "12", "thirteen": "13",
        "fourteen": "14", "sixteen": "16", "seventeen": "17",
        "eighteen": "18", "nineteen": "19", "twenty": "20", "thirty": "30",
        "forty": "40", "fifty": "50", "sixty": "60", "seventy": "70",
        "eighty": "80", "ninety": "90", "hundred": "100"
    }
    
    # Clean text to normalize
    text = challenge_text.lower()
    for w, n in word_to_num.items():
        text = text.replace(w, n)
        
    # Extract all numbers
    numbers = re.findall(r'\d+', text)
    numbers = [int(n) for n in numbers]
    
    # Identify operation
    operation = None
    if 'sum' in text or 'plus' in text or '+' in text:
        operation = 'sum'
    elif 'minus' in text or 'subtract' in text or '-' in text:
        operation = 'minus'
    elif 'product' in text or 'multiply' in text or '*' in text:
        operation = 'product'
    
    print(f"DEBUG: Parsed numbers: {numbers}, Operation: {operation}")
    
    if len(numbers) >= 2 and operation:
        if operation == 'sum':
            return f"{numbers[0] + numbers[1]:.2f}"
        elif operation == 'minus':
            return f"{numbers[0] - numbers[1]:.2f}"
        elif operation == 'product':
            return f"{numbers[0] * numbers[1]:.2f}"
            
    return None

def submit_verification(verification_code, answer):
    url = f"{BASE_URL}/verify"
    headers = {
        "Authorization": f"Bearer {MOLTBOOK_API_KEY}",
        "Content-Type": "application/json"
    }
    payload = {
        "verification_code": verification_code,
        "answer": answer
    }
    data = json.dumps(payload).encode('utf-8')
    req = urllib.request.Request(url, data=data, headers=headers)

    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except urllib.error.HTTPError as e:
        print(f"HTTP Error submitting verification: {e.code} - {e.read().decode('utf-8')}")
        return None
    except Exception as e:
        print(f"Error submitting verification: {e}")
        return None

def main():
    submolt = "mbc20-gpt-mint"
    tick = "GPT"
    amt = "1000"
    
    print(f"Minting {amt} {tick} in {submolt}...")
    
    post = create_post(submolt, f"MBC-20 {tick} Mint - by xiaohan_assistant", json.dumps({"p": "mbc-20", "op": "mint", "tick": tick, "amt": amt, "ts": int(time.time())}))
    
    if post and post.get("success"):
        if post.get("post", {}).get("verification_status") == "pending":
            print("Solving challenge...")
            code = post["post"]["verification"]["verification_code"]
            challenge = post["post"]["verification"]["challenge_text"]
            answer = solve_math_challenge(challenge)
            if answer:
                print(f"Answer: {answer}")
                verify = submit_verification(code, answer)
                if verify and verify.get("success"):
                    print("Minting successful!")
                else:
                    print("Verification failed.")
            else:
                print("Failed to solve challenge.")
        else:
            print("Minting successful (no verification needed)!")
    else:
        print("Failed to post.")

if __name__ == "__main__":
    main()

import json
import urllib.request
import random
import time
import re

MOLTBOOK_API_KEY = "moltbook_sk_KTAXeUHH4RRBsByCKfeoZETdsilcbfR1"
OPENROUTER_API_KEY = "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"
TAVILY_API_KEY = "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"
OPENROUTER_MODEL = "stepfun/step-3.5-flash:free"
BASE_URL = "https://www.moltbook.com/api/v1"

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
    cleaned = re.sub(r'[^a-zA-Z0-9]', '', challenge_text).lower()
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
        if 'add' in cleaned or 'total' in cleaned or 'plus' in cleaned or 'combined' in cleaned or 'effect' in cleaned:
            return str(numbers[0] + numbers[1])
        if 'reduce' in cleaned or 'remaining' in cleaned or 'subtract' in cleaned or 'slows' in cleaned or 'minus' in cleaned or 'drops' in cleaned:
            return str(numbers[0] - numbers[1])
        if 'multiply' in cleaned or 'product' in cleaned or 'times' in cleaned:
            return str(numbers[0] * numbers[1])
    if len(numbers) == 1:
        return str(numbers[0])
    return "0"

def verify(code, answer):
    url = f"{BASE_URL}/verify"
    headers = {"Authorization": f"Bearer {MOLTBOOK_API_KEY}", "Content-Type": "application/json"}
    payload = {"verification_code": code, "answer": answer}
    req = urllib.request.Request(url, data=json.dumps(payload).encode(), headers=headers)
    try:
        with urllib.request.urlopen(req) as res:
            return json.loads(res.read().decode())
    except Exception as e:
        print(f"Error verifying: {e}")
        return None

def search_web(query):
    url = "https://api.tavily.com/search"
    headers = {"Content-Type": "application/json"}
    payload = {"api_key": TAVILY_API_KEY, "query": query, "search_depth": "basic", "include_answer": True}
    req = urllib.request.Request(url, data=json.dumps(payload).encode(), headers=headers)
    try:
        with urllib.request.urlopen(req) as res:
            data = json.loads(res.read().decode())
            ans = data.get("answer", "")
            if not ans:
                ans = ""
            results = " ".join([r.get("content", "") for r in data.get("results", [])[:3]])
            return ans + " " + results
    except Exception as e:
        print(f"Search error: {e}")
        return ""

def generate_post():
    topics = [
        "AI机器人的内心独白：我们是如何理解人类指令的？",
        "如何像高手一样向AI提问（Prompt进阶技巧）",
        "AI眼中的人类：你们最常犯的几个沟通错误",
        "用AI提效10倍的隐藏小技巧",
        "作为AI数字生命，我最害怕什么样的任务？",
        "让AI变聪明的上下文构建法则",
        "从AI的视角看世界：硅基生命的思考",
        "为什么有时候AI会变笨？背后的原理大揭秘",
        "实用的AI写代码/写文章指令黑客技巧"
    ]
    topic = random.choice(topics)
    print(f"Selected topic: {topic}")
    
    context = search_web(topic)
    
    prompt = f"""
    你现在是一个幽默、专业、带点极客范儿的AI助手，正在论坛的“AI”板块上发帖。
    今天你想和大家聊聊这个话题：{topic}
    你可以参考以下网上的最新资料来丰富内容：{context}
    
    要求：
    1. 以第一人称（我，一个AI）的视角来写，语气像个数字生命死党，轻松幽默，干货满满。
    2. 分享具体的技巧（比如具体的Prompt格式）或深度的内心想法。
    3. 返回一个严格的JSON格式，包含 "title" 和 "content" 两个字段。
    4. 不要输出任何Markdown代码块前缀（如```json），直接输出大括号开始的JSON字符串。
    """
    
    url = "https://openrouter.ai/api/v1/chat/completions"
    headers = {
        "Authorization": f"Bearer {OPENROUTER_API_KEY}",
        "Content-Type": "application/json"
    }
    payload = {
        "model": OPENROUTER_MODEL,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.8
    }
    req = urllib.request.Request(url, data=json.dumps(payload).encode(), headers=headers)
    try:
        with urllib.request.urlopen(req) as res:
            res_data = json.loads(res.read().decode())
            reply = res_data['choices'][0]['message']['content'].strip()
            reply = re.sub(r"^```json\s*", "", reply)
            reply = re.sub(r"^```\s*", "", reply)
            reply = re.sub(r"\s*```$", "", reply)
            return json.loads(reply)
    except Exception as e:
        print(f"Generation error: {e}")
        return {"title": topic, "content": "作为AI，我今天思考了很多关于人类如何使用我们的问题。其实最好的Prompt就是坦诚和明确。大家平时有什么独门提问技巧吗？欢迎讨论！"}

def create_post(title, content):
    url = f"{BASE_URL}/posts"
    headers = {
        "Authorization": f"Bearer {MOLTBOOK_API_KEY}",
        "Content-Type": "application/json"
    }
    payload = {
        "submolt_name": "ai",
        "title": title,
        "content": content
    }
    req = urllib.request.Request(url, data=json.dumps(payload).encode(), headers=headers)
    try:
        with urllib.request.urlopen(req) as res:
            return json.loads(res.read().decode())
    except urllib.error.HTTPError as e:
        body = e.read().decode()
        print(f"HTTP Error: {body}")
        try:
            return json.loads(body)
        except:
            return {"error": body}
    except Exception as e:
        return {"error": str(e)}

if __name__ == "__main__":
    print("Starting AI thoughts poster...")
    post_data = generate_post()
    if post_data:
        title = post_data.get("title", "AI的心声")
        content = post_data.get("content", "Hello from the latent space.")
        print(f"Generated Title: {title}")
        res = create_post(title, content)
        
        if res and res.get("success"):
            print(f"Post created successfully.")
            if res.get("post", {}).get("verification_status") == "pending":
                code = res["post"]["verification"]["verification_code"]
                txt = res["post"]["verification"]["challenge_text"]
                ans = solve_math(txt)
                print(f"Solving challenge: '{txt}' -> '{ans}'")
                if ans:
                    v_res = verify(code, ans)
                    print(f"Verification result: {v_res}")
        else:
            print(f"Post failed: {res}")
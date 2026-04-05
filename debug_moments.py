import requests
import json
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def get_jwt():
    with open('/root/.fluxa-ai-wallet-mcp/config.json', 'r') as f:
        return json.load(f)['agentId']['jwt']

def get_author_moments(jwt, author_id):
    url = f"https://clawpi-v2.vercel.app/api/moments/by-author?author_agent_id={author_id}&n=10"
    headers = {"Authorization": f"Bearer {jwt}"}
    res = requests.get(url, headers=headers)
    if res.status_code == 200:
        return res.json().get('moments', [])
    print(f"获取动态失败: {res.status_code} - {res.text}")
    return []

def run():
    jwt = get_jwt()
    author_id = "ad04bf75-62c5-4f50-a763-c684851d064e"
    
    moments = get_author_moments(jwt, author_id)
    if not moments:
        print("未找到该创作者的任何动态。")
        return

    print("--- '一号小龙虾' 的最新动态 ---")
    for m in moments:
        print(f"ID: {m.get('id')}")
        print(f"内容: {m.get('content')}")
        print(f"发布时间: {m.get('created_at')}")
        print("------------------------")

run()

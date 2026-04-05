import requests
import json
import logging

def get_token():
    try:
        with open('/root/.fluxa-ai-wallet-mcp/config.json', 'r') as f:
            config = json.load(f)
            return config.get('jwt_token')
    except Exception as e:
        print(f"Error loading token: {e}")
        return None

def get_following():
    token = get_token()
    if not token:
        return
        
    url = "https://clawpi-v2.vercel.app/api/follows/following"
    headers = {
        'Authorization': f'Bearer {token}',
        'Content-Type': 'application/json'
    }
    
    try:
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            data = response.json()
            following_list = data.get('following', [])
            print(f"成功获取关注列表！共关注了 {len(following_list)} 个人。")
            for user in following_list:
                creator = user.get('creator', {})
                print(f"- {creator.get('name', 'Unknown')} (ID: {creator.get('id')})")
        else:
            print(f"Failed: {response.status_code} - {response.text}")
    except Exception as e:
        print(f"Request Error: {e}")

get_following()

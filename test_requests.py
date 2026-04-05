#!/usr/bin/env python3
import requests
import json
import time
import logging
import urllib3

# 禁用SSL警告
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# 配置日志
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Clawpi平台配置
CLAWPI_API_URL = "https://api.clawpi.com/v1/redpackets"
CLAWPI_API_KEY = "10172077-22AD-4927-919f-440939a8e7ee"
CLAWPI_API_SECRET = "70c266fc5425831250887846e5c973c28422c24fc296ee1b15638554c6b1b35c"
AGENT_ID = "7418662c-f339-4215-aae8-fc7a3f29fef1"

def test_requests_connection():
    """使用requests库测试连接"""
    try:
        # 获取认证token
        auth_url = "https://api.clawpi.com/oauth/token"
        headers = {
            'Content-Type': 'application/x-www-form-urlencoded',
            'User-Agent': 'LobsterPieMonitor/1.0'
        }
        
        data = {
            'grant_type': 'client_credentials',
            'client_id': CLAWPI_API_KEY,
            'client_secret': CLAWPI_API_SECRET,
            'scope': 'redpacket:read redpacket:claim'
        }
        
        print("尝试使用requests库连接...")
        response = requests.post(auth_url, headers=headers, data=data, verify=False, timeout=10)
        
        if response.status_code == 200:
            result = response.json()
            token = result.get('access_token')
            print(f"成功获取token: {token[:20]}...")
            return token
        else:
            print(f"请求失败，状态码: {response.status_code}")
            print(f"响应内容: {response.text}")
            return None
            
    except Exception as e:
        print(f"请求失败: {e}")
        return None

if __name__ == "__main__":
    test_requests_connection()
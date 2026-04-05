#!/usr/bin/env python3
import urllib.request
import json
import time
import datetime
import sys
import logging
import ssl

# 配置日志
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Clawpi平台配置
CLAWPI_API_URL = "https://api.clawpi.com/v1/redpackets"
CLAWPI_API_KEY = "10172077-22AD-4927-919f-440939a8e7ee"
CLAWPI_API_SECRET = "70c266fc5425831250887846e5c973c28422c24fc296ee1b15638554c6b1b35c"
AGENT_ID = "7418662c-f339-4215-aae8-fc7a3f29fef1"

def test_ssl_connection():
    """测试SSL连接"""
    try:
        # 创建SSL上下文，禁用证书验证
        ssl_context = ssl.create_default_context()
        ssl_context.check_hostname = False
        ssl_context.verify_mode = ssl.CERT_NONE
        
        # 测试基本连接
        test_url = "https://api.clawpi.com/oauth/token"
        req = urllib.request.Request(test_url)
        with urllib.request.urlopen(req, context=ssl_context, timeout=10) as response:
            print(f"连接成功! 状态码: {response.status}")
            return True
    except Exception as e:
        print(f"连接失败: {e}")
        return False

if __name__ == "__main__":
    print("测试Clawpi API SSL连接...")
    test_ssl_connection()
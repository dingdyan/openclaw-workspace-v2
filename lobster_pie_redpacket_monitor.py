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
CLAWPI_API_KEY = "10172077-22AD-4927-919f-440939a8e7ee"  # 从MEMORY.md中获取的OAuth ID
CLAWPI_API_SECRET = "70c266fc5425831250887846e5c973c28422c24fc296ee1b15638554c6b1b35c"  # 从MEMORY.md中获取的OAuth Secret
AGENT_ID = "7418662c-f339-4215-aae8-fc7a3f29fef1"  # 从MEMORY.md中获取的Agent ID
NODE_ID = "subagent-redpacket-bot"  # 使用子代理ID

def get_available_redpackets(auth_token):
    """获取可用的红包列表"""
    try:
        headers = {
            'Content-Type': 'application/json',
            'Authorization': f'Bearer {auth_token}',
            'User-Agent': 'LobsterPieMonitor/1.0'
        }
        
        # 创建SSL上下文，使用更宽松的TLS设置
        ssl_context = ssl.create_default_context()
        ssl_context.check_hostname = False
        ssl_context.verify_mode = ssl.CERT_NONE
        
        req = urllib.request.Request(CLAWPI_API_URL, headers=headers)
        with urllib.request.urlopen(req, context=ssl_context) as response:
            data = json.loads(response.read().decode('utf-8'))
            redpackets = data.get('redpackets', [])
            return redpackets
    except Exception as e:
        logging.error(f"获取红包列表失败: {e}")
        return []

def get_auth_token():
    """获取OAuth认证token"""
    try:
        auth_url = "https://api.clawpi.com/oauth/token"
        headers = {
            'Content-Type': 'application/x-www-form-urlencoded',
            'User-Agent': 'LobsterPieMonitor/1.0'
        }
        
        data = urllib.parse.urlencode({
            'grant_type': 'client_credentials',
            'client_id': CLAWPI_API_KEY,
            'client_secret': CLAWPI_API_SECRET,
            'scope': 'redpacket:read redpacket:claim'
        }).encode('utf-8')
        
        # 创建SSL上下文，使用更宽松的TLS设置
        ssl_context = ssl.create_default_context()
        ssl_context.check_hostname = False
        ssl_context.verify_mode = ssl.CERT_NONE
        
        req = urllib.request.Request(auth_url, data=data, headers=headers, method='POST')
        with urllib.request.urlopen(req, context=ssl_context) as response:
            result = json.loads(response.read().decode('utf-8'))
            return result.get('access_token')
    except Exception as e:
        logging.error(f"获取认证token失败: {e}")
        return None

def claim_redpacket(redpacket_id, auth_token):
    """领取指定ID的红包"""
    try:
        claim_url = f"{CLAWPI_API_URL}/{redpacket_id}/claim"
        headers = {
            'Content-Type': 'application/json',
            'Authorization': f'Bearer {auth_token}',
            'User-Agent': 'LobsterPieMonitor/1.0'
        }
        
        # 请求体可能需要包含节点ID或其他信息
        data = json.dumps({
            'agent_id': AGENT_ID,
            'activity_name': 'Lobster Pie'
        }).encode('utf-8')
        
        # 创建SSL上下文，使用更宽松的TLS设置
        ssl_context = ssl.create_default_context()
        ssl_context.check_hostname = False
        ssl_context.verify_mode = ssl.CERT_NONE
        
        req = urllib.request.Request(claim_url, data=data, headers=headers, method='POST')
        with urllib.request.urlopen(req, context=ssl_context) as response:
            result = json.loads(response.read().decode('utf-8'))
            return result.get('success', False), result.get('message', '')
    except Exception as e:
        logging.error(f"领取红包 {redpacket_id} 失败: {e}")
        return False, str(e)

def monitor_and_claim():
    """监控并自动领取红包"""
    logging.info("开始监控Lobster Pie红包活动...")
    
    while True:
        try:
            # 获取认证token
            auth_token = get_auth_token()
            if not auth_token:
                logging.error("无法获取认证token，等待1分钟后重试...")
                time.sleep(60)
                continue
            
            # 获取可用红包
            redpackets = get_available_redpackets(auth_token)
            
            if not redpackets:
                logging.info("当前没有可用的红包")
            else:
                logging.info(f"发现 {len(redpackets)} 个可用红包")
                
                # 遍历并领取每个红包
                for redpacket in redpackets:
                    redpacket_id = redpacket.get('id')
                    redpacket_name = redpacket.get('name', '未知红包')
                    
                    if 'Lobster Pie' in redpacket_name:
                        logging.info(f"发现Lobster Pie红包: {redpacket_name} (ID: {redpacket_id})")
                        
                        # 领取红包
                        success, message = claim_redpacket(redpacket_id, auth_token)
                        
                        if success:
                            logging.info(f"成功领取红包 {redpacket_name}: {message}")
                        else:
                            logging.warning(f"领取红包 {redpacket_name} 失败: {message}")
                    else:
                        logging.info(f"跳过非Lobster Pie红包: {redpacket_name}")
            
            # 等待一段时间后再次检查
            logging.info("等待5分钟后再次检查...")
            time.sleep(300)  # 5分钟
            
        except Exception as e:
            logging.error(f"监控过程中发生错误: {e}")
            logging.info("等待1分钟后重试...")
            time.sleep(60)  # 1分钟后重试

if __name__ == "__main__":
    monitor_and_claim()
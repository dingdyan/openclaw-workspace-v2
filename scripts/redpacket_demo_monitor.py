#!/usr/bin/env python3
"""
ClawPi红包监控演示系统
只监控红包状态，不涉及FluxA钱包操作
"""

import json
import requests
import time
import logging
import os
from datetime import datetime, timedelta
from typing import List, Dict, Optional

# 配置文件路径
CONFIG_FILE = "/root/.openclaw/workspace/config/redpacket_monitor_config.json"

def load_config():
    """从配置文件加载配置"""
    try:
        with open(CONFIG_FILE, 'r', encoding='utf-8') as f:
            config = json.load(f)
        
        # 合并配置
        return {
            "api_base_url": config.get("api_endpoints", {}).get("clawpi_base", "https://clawpi-v2.vercel.app"),
            "check_interval": config.get("settings", {}).get("check_interval", 30),
            "max_retries": config.get("settings", {}).get("max_retries", 3),
            "retry_delay": config.get("settings", {}).get("retry_delay", 5),
            "creators": config.get("creators", []),
            "min_amount_usdc": config.get("settings", {}).get("min_amount_usdc", 0.01),
            "agent_id": config.get("agent_info", {}).get("agent_id", "7418662c-f339-4215-aae8-fc7a3f29fef1")
        }
    except Exception as e:
        print(f"加载配置文件失败: {e}")
        # 使用默认配置
        return {
            "api_base_url": "https://clawpi-v2.vercel.app",
            "check_interval": 30,
            "max_retries": 3,
            "retry_delay": 5,
            "creators": ["xiaohongshu", "bilibili", "douyin", "weibo", "zhihu", "kuaishou"],
            "min_amount_usdc": 0.01,
            "agent_id": "7418662c-f339-4215-aae8-fc7a3f29fef1"
        }

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('/root/.openclaw/workspace/logs/redpacket_demo.log'),
        logging.StreamHandler()
    ]
)

# 动态配置
CONFIG = load_config()

class RedPacketMonitor:
    def __init__(self):
        self.jwt_token = self._get_jwt_token()
        self.session = requests.Session()
        self.session.headers.update({
            'Authorization': f'Bearer {self.jwt_token}',
            'User-Agent': 'ClawPi-RedPacket-Monitor/1.0'
        })
        self.processed_packets = set()  # 记录已处理的红包ID
        self.last_check_time = {}  # 记录每个红包的检测时间
        
    def _get_jwt_token(self) -> str:
        """获取JWT token"""
        try:
            with open('/root/.fluxa-ai-wallet-mcp/config.json', 'r') as f:
                config = json.load(f)
            return config['agentId']['jwt']
        except Exception as e:
            logging.error(f"获取JWT token失败: {e}")
            raise
    
    def _make_request(self, url: str, method: str = 'GET', data: Optional[Dict] = None, 
                      max_retries: int = None) -> Optional[Dict]:
        """发送HTTP请求并处理错误重试"""
        if max_retries is None:
            max_retries = CONFIG['max_retries']
            
        for attempt in range(max_retries):
            try:
                if method == 'GET':
                    response = self.session.get(url, timeout=10)
                elif method == 'POST':
                    response = self.session.post(url, json=data, timeout=10)
                else:
                    raise ValueError(f"不支持的HTTP方法: {method}")
                
                if response.status_code == 200:
                    return response.json()
                elif response.status_code == 401:
                    logging.error("JWT token失效，尝试刷新...")
                    self.jwt_token = self._get_jwt_token()
                    self.session.headers['Authorization'] = f'Bearer {self.jwt_token}'
                    continue
                elif response.status_code >= 500:
                    logging.warning(f"服务器错误 (HTTP {response.status_code}), 尝试 {attempt + 1}/{max_retries}")
                    time.sleep(CONFIG['retry_delay'])
                    continue
                else:
                    logging.error(f"请求失败: HTTP {response.status_code}")
                    return None
                    
            except requests.exceptions.RequestException as e:
                logging.warning(f"请求异常: {e}, 尝试 {attempt + 1}/{max_retries}")
                if attempt < max_retries - 1:
                    time.sleep(CONFIG['retry_delay'])
        
        logging.error(f"请求失败，已达到最大重试次数: {url}")
        return None
    
    def check_api_status(self) -> bool:
        """检查API连接状态"""
        url = f"{CONFIG['api_base_url']}/api/redpacket/available?n=1&offset=0"
        result = self._make_request(url)
        
        if result and result.get('success'):
            logging.info("✅ Clawpi API连接正常")
            return True
        else:
            logging.error("❌ Clawpi API连接异常")
            return False
    
    def get_available_redpackets(self) -> List[Dict]:
        """获取可用的红包列表"""
        url = f"{CONFIG['api_base_url']}/api/redpacket/available?n=50&offset=0"
        result = self._make_request(url)
        
        if result and result.get('success'):
            redpackets = result.get('redPackets', [])
            logging.info(f"获取到 {len(redpackets)} 个红包信息")
            return redpackets
        else:
            logging.error("获取红包列表失败")
            return []
    
    def is_target_creator(self, redpacket: Dict) -> bool:
        """检查红包是否来自目标创作者"""
        creator_name = redpacket.get('creator_name', '').lower()
        packet_title = redpacket.get('title', '').lower()
        packet_description = redpacket.get('description', '').lower()
        
        # 检查是否在目标创作者列表中
        for creator in CONFIG['creators']:
            if creator.lower() in creator_name or creator.lower() in packet_title or creator.lower() in packet_description:
                return True
        
        return False
    
    def is_new_redpacket(self, redpacket_id: str) -> bool:
        """检查是否是新红包"""
        current_time = datetime.now()
        
        # 如果红包从未处理过，视为新红包
        if redpacket_id not in self.processed_packets:
            self.processed_packets.add(redpacket_id)
            return True
        
        # 如果上次处理超过1分钟，也视为新红包（可能重新开放）
        if redpacket_id in self.last_check_time:
            last_time = self.last_check_time[redpacket_id]
            if current_time - last_time > timedelta(minutes=1):
                return True
        
        return False
    
    def process_redpackets(self):
        """处理所有符合条件的红包"""
        logging.info("开始处理红包...")
        
        redpackets = self.get_available_redpackets()
        if not redpackets:
            logging.info("当前没有可用的红包")
            return
        
        processed_count = 0
        new_count = 0
        eligible_count = 0
        
        for redpacket in redpackets:
            redpacket_id = redpacket.get('id')
            creator_name = redpacket.get('creator_name', '未知创作者')
            amount_usdc = int(redpacket.get('per_amount', 0)) / 1000000
            can_claim = redpacket.get('can_claim', False)
            already_claimed = redpacket.get('already_claimed', False)
            title = redpacket.get('title', '无标题')
            
            # 更新检测时间
            self.last_check_time[redpacket_id] = datetime.now()
            
            # 检查是否为目标创作者的红包
            if not self.is_target_creator(redpacket):
                continue
            
            # 检查金额门槛
            if amount_usdc < CONFIG['min_amount_usdc']:
                logging.info(f"跳过金额过小的红包: {amount_usdc:.2f} USDC (ID: {redpacket_id})")
                continue
            
            # 检查是否可领取
            if not can_claim or already_claimed:
                logging.info(f"红包不可领取 (can_claim: {can_claim}, already_claimed: {already_claimed})")
                continue
            
            # 检查是否是新红包
            if not self.is_new_redpacket(redpacket_id):
                continue
            
            logging.info(f"🎯 发现新红包: {creator_name} - {title}")
            logging.info(f"   - 金额: {amount_usdc:.2f} USDC")
            logging.info(f"   - ID: {redpacket_id}")
            logging.info(f"   - 可领取: {can_claim}")
            
            processed_count += 1
            new_count += 1
            eligible_count += 1
            
            # 模拟领取操作（仅演示，不实际领取）
            logging.info(f"🎯 [演示] 准备领取红包 {redpacket_id}...")
            logging.info(f"🎯 [演示] 金额: {amount_usdc:.2f} USDC")
            logging.info(f"🎯 [演示] 创作者: {creator_name}")
            logging.info(f"🎯 [演示] 状态: 待领取")
        
        logging.info(f"本轮处理完成:")
        logging.info(f"  - 总红包数: {len(redpackets)}")
        logging.info(f"  - 目标创作者红包: {processed_count}")
        logging.info(f"  - 新发现红包: {new_count}")
        logging.info(f"  - 可领取红包: {eligible_count}")
        
        if eligible_count > 0:
            logging.info(f"💡 提示: 发现 {eligible_count} 个符合条件的红包，需要手动领取")
    
    def run(self):
        """运行监控循环"""
        # 重新加载配置
        global CONFIG
        CONFIG = load_config()
        
        logging.info("=== ClawPi红包监控系统启动 ===")
        logging.info(f"监控创作者: {CONFIG['creators']}")
        logging.info(f"最小金额门槛: {CONFIG['min_amount_usdc']} USDC")
        logging.info(f"检查间隔: {CONFIG['check_interval']} 秒")
        logging.info(f"Agent ID: {CONFIG['agent_id']}")
        logging.info("=========================================")
        logging.info("💡 注意: 当前为演示模式，仅监控红包状态，不自动领取")
        
        # 首次检查API状态
        if not self.check_api_status():
            logging.error("API连接失败，无法继续")
            return
        
        # 主循环
        while True:
            try:
                logging.info(f"开始新一轮红包检查... ({datetime.now().strftime('%H:%M:%S')})")
                self.process_redpackets()
                
                logging.info(f"检查完成，等待 {CONFIG['check_interval']} 秒后下一轮...")
                time.sleep(CONFIG['check_interval'])
                
            except KeyboardInterrupt:
                logging.info("收到停止信号，正在退出...")
                break
            except Exception as e:
                logging.error(f"监控过程中发生未处理的错误: {e}")
                logging.info("等待 60 秒后重试...")
                time.sleep(60)

if __name__ == "__main__":
    monitor = RedPacketMonitor()
    monitor.run()
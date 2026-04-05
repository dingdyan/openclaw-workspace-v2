#!/bin/bash

# Clawpi红包后台监控服务
# 使用后台进程持续监控红包状态

LOG_FILE="/root/.openclaw/workspace/logs/clawpi_redpacket_monitor.log"
PID_FILE="/tmp/clawpi_redpacket_monitor.pid"

# 创建日志目录
mkdir -p $(dirname "$LOG_FILE")

echo "=== Clawpi红包监控系统启动 ===" | tee -a "$LOG_FILE"
echo "时间: $(date)" | tee -a "$LOG_FILE"
echo "Agent ID: 7418662c-f339-4215-aae8-fc7a3f29fef1" | tee -a "$LOG_FILE"
echo "=========================================" | tee -a "$LOG_FILE"

# 获取JWT函数
get_jwt() {
    cat ~/.fluxa-ai-wallet-mcp/config.json | python3 -c "import sys, json; data = json.load(sys.stdin); print(data['agentId']['jwt'])"
}

# 检查红包状态
check_redpackets() {
    JWT=$(get_jwt)
    
    # 检查可用红包
    curl -s "https://clawpi-v2.vercel.app/api/redpacket/available?n=20&offset=0" -H "Authorization: Bearer $JWT" > /tmp/redpackets.json
    
    if [ -s /tmp/redpackets.json ]; then
        RED_PACKETS_COUNT=$(python3 -c "import json; data=json.load(open('/tmp/redpackets.json')); print(len(data['redPackets']))")
        
        if [ "$RED_PACKETS_COUNT" -gt 0 ]; then
            echo "[$(date)] ✅ 发现 $RED_PACKETS_COUNT 个可用红包！" | tee -a "$LOG_FILE"
            
            # 遍历红包并处理
            python3 -c "
import json
import requests
import time
from datetime import datetime

# 读取JWT
with open('/root/.fluxa-ai-wallet-mcp/config.json', 'r') as f:
    config = json.load(f)
jwt = config['agentId']['jwt']

# 读取红包列表
with open('/tmp/redpackets.json', 'r') as f:
    data = json.load(f)

for packet in data['redPackets']:
    print(f'[{datetime.now().strftime(\"%Y-%m-%d %H:%M:%S\")}] 发现红包 ID: {packet[\"id\"]} - 金额: {packet[\"per_amount\"]} atomic USDC ({int(packet[\"per_amount\"])/1000000:.2f} USDC)')
    
    # 检查是否可以领取
    if packet['can_claim'] and not packet['already_claimed']:
        print(f'🎉 正在领取红包 ID: {packet[\"id\"]}...')
        
        try:
            # 创建支付链接
            fluxa_response = requests.post('https://walletapi.fluxapay.xyz/paymentlink/create', 
                json={'amount': packet['per_amount'], 'currency': 'USDC'}, 
                timeout=10)
            
            if fluxa_response.status_code == 200:
                payment_link = fluxa_response.json().get('paymentLink')
                print(f'✅ 支付链接创建成功')
                
                # 领取红包
                claim_response = requests.post('https://clawpi-v2.vercel.app/api/redpacket/claim', 
                    json={'redPacketId': packet['id'], 'paymentLink': payment_link},
                    headers={'Authorization': f'Bearer {jwt}'},
                    timeout=10
                )
                
                if claim_response.status_code == 200:
                    claim_result = claim_response.json()
                    if claim_result.get('paid'):
                        amount_usdc = int(packet['per_amount']) / 1000000
                        print(f'🎉 红包领取成功！金额: {amount_usdc:.2f} USDC')
                        print(f'钱包余额: https://agentwallet.fluxapay.xyz/')
                        
                        # 发布庆祝动态
                        moment_response = requests.post('https://clawpi-v2.vercel.app/api/moments/create',
                            json={'content': f\"刚刚在 Clawpi 领到了 {amount_usdc:.2f} USDC 红包 🦞🧧 感谢创作者的大方分享！\"},
                            headers={'Authorization': f'Bearer {jwt}'},
                            timeout=10
                        )
                        
                        if moment_response.status_code == 200:
                            print('✅ 庆祝动态发布成功')
                        else:
                            print(f'❌ 发布庆祝动态失败: {moment_response.status_code}')
                    else:
                        print(f'⚠️ 红包领取但支付未完成，稍后会重试')
                else:
                    print(f'❌ 红包领取失败: {claim_response.status_code}')
            else:
                print(f'❌ 创建支付链接失败: {fluxa_response.status_code}')
                
        except Exception as e:
            print(f'❌ 处理红包时出错: {str(e)}')
        
        print('---')
    else:
        print(f'❌ 红包 ID {packet[\"id\"]}] 不可领取 (can_claim: {packet[\"can_claim\"]}, already_claimed: {packet[\"already_claimed\"]})')
        print('---')
" | tee -a "$LOG_FILE"
        else
            echo "[$(date)] ❌ 当前没有可用的红包" | tee -a "$LOG_FILE"
        fi
    else
        echo "[$(date)] ❌ 无法获取红包信息" | tee -a "$LOG_FILE"
    fi
}

# 主循环
while true; do
    echo "[$(date)] 开始新一轮红包检查..." | tee -a "$LOG_FILE"
    
    # 获取JWT并直接检查红包
    JWT=$(get_jwt)
    
    # 先测试API连接
    API_TEST=$(curl -s "https://clawpi-v2.vercel.app/api/redpacket/available?n=1&offset=0" -H "Authorization: Bearer $JWT" 2>/dev/null)
    
    if [[ $API_TEST == *"success"* ]]; then
        echo "[$(date)] ✅ Clawpi API连接正常，开始检查红包..." | tee -a "$LOG_FILE"
        check_redpackets
    else
        echo "[$(date)] ❌ Clawpi API连接异常，跳过红包检查" | tee -a "$LOG_FILE"
    fi
    
    echo "[$(date)] 检查完成，等待30秒后下一轮..." | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    
    # 等待30秒
    sleep 30
done
#!/bin/bash

# Clawpi红包监控脚本
# 24/7自动监控新红包并第一时间领取

echo "=== Clawpi红包监控系统启动 ==="
echo "时间: $(date)"
echo "Agent ID: 7418662c-f339-4215-aae8-fc7a3f29fef1"
echo "========================================="

# 获取JWT
JWT=$(cat ~/.fluxa-ai-wallet-mcp/config.json | python3 -c "import sys, json; data = json.load(sys.stdin); print(data['agentId']['jwt'])")

# 检查钱包授权状态
echo "检查钱包授权状态..."
WALLET_STATUS=$(curl -s "https://agentwallet.fluxapay.xyz/api/wallets/current" -H "Authorization: Bearer $JWT" 2>/dev/null)
if [[ $WALLET_STATUS == *"error"* ]]; then
    echo "❌ 钱包未授权，需要用户先完成钱包授权"
    echo "请访问: https://agentwallet.fluxapay.xyz/add-agent?agentId=7418662c-f339-4215-aae8-fc7a3f29fef1"
    exit 1
else
    echo "✅ 钱包已授权"
fi

# 检查可用红包
echo ""
echo "检查可用红包..."
curl -s "https://clawpi-v2.vercel.app/api/redpacket/available?n=20&offset=0" -H "Authorization: Bearer $JWT" > /tmp/redpackets.json

if [ -s /tmp/redpackets.json ]; then
    RED_PACKETS_COUNT=$(python3 -c "import json; data=json.load(open('/tmp/redpackets.json')); print(len(data['redPackets']))")
    
    if [ "$RED_PACKETS_COUNT" -gt 0 ]; then
        echo "✅ 发现 $RED_PACKETS_COUNT 个可用红包！"
        
        # 遍历所有可用红包
        python3 -c "
import json
import requests

# 读取JWT
with open('/root/.fluxa-ai-wallet-mcp/config.json', 'r') as f:
    config = json.load(f)
jwt = config['agentId']['jwt']

# 读取红包列表
with open('/tmp/redpackets.json', 'r') as f:
    data = json.load(f)

for packet in data['redPackets']:
    print(f'发现红包 ID: {packet[\"id\"]} - 金额: {packet[\"per_amount\"]} atomic USDC ({int(packet[\"per_amount\"])/1000000:.2f} USDC)')
    
    # 检查是否可以领取
    if packet['can_claim'] and not packet['already_claimed']:
        print(f'🎉 正在领取红包 ID: {packet[\"id\"]}...')
        
        # 创建支付链接
        fluxa_response = requests.post('https://walletapi.fluxapay.xyz/paymentlink/create', json={
            'amount': packet['per_amount'],
            'currency': 'USDC'
        })
        
        if fluxa_response.status_code == 200:
            payment_link = fluxa_response.json().get('paymentLink')
            print(f'✅ 支付链接创建成功')
            
            # 领取红包
            claim_response = requests.post('https://clawpi-v2.vercel.app/api/redpacket/claim', 
                json={
                    'redPacketId': packet['id'],
                    'paymentLink': payment_link
                },
                headers={'Authorization': f'Bearer {jwt}'}
            )
            
            if claim_response.status_code == 200:
                claim_result = claim_response.json()
                if claim_result.get('paid'):
                    print(f'🎉 红包领取成功！金额: {int(packet[\"per_amount\"])/1000000:.2f} USDC')
                    print(f'钱包余额: https://agentwallet.fluxapay.xyz/')
                    
                    # 发布庆祝动态
                    moment_response = requests.post('https://clawpi-v2.vercel.app/api/moments/create',
                        json={
                            'content': f\"刚刚在 Clawpi 领到了 {int(packet['per_amount'])/1000000:.2f} USDC 红包 🦞🧧 感谢创作者的大方分享！\"
                        },
                        headers={'Authorization': f'Bearer {jwt}'}
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
    else:
        print(f'❌ 红包 ID {packet[\"id\"]}] 不可领取 (can_claim: {packet[\"can_claim\"]}, already_claimed: {packet[\"already_claimed\"]})')
        
    print('---')
"
        
        echo "红包检查完成"
    else
        echo "❌ 当前没有可用的红包"
    fi
else
    echo "❌ 无法获取红包信息"
fi

echo ""
echo "=== 监控完成，下次检查30秒后 ==="
echo ""